import UIKit
import Flutter
import VivalnkSDK


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate,vlBLEDelegates, BluetoothConnectListenerDelegate,BluetoothScanListenerDelegate,BluetoothStateListenerDelegate{
    var deviceList = NSMutableArray.init()
    
    
    var jsonArray=[Any]();
    var  oximetryid=""
    var studysession=""
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      
      let methodChannel = FlutterMethodChannel(name: "com.dmt.patientapp/device",
                                                   binaryMessenger: controller.binaryMessenger)
      methodChannel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          
        
    
          switch call.method{
          case "init":
              VVBleManager.shareInstance().delegate = self
              VVBleManager.shareInstance().bleStateDelegate = self
              VVBleManager.shareInstance().scanDelegate = self
              VVBleManager.shareInstance().connectDelegate = self
            result(true)
          break;
          case "connectDevice":
              self.deviceList.removeAllObjects()
              self.scanECGDevice()
              var deviceName = ""
              let arg = call.arguments as! [String:Any]
              deviceName = arg["name"] as! String
             debugPrint("deviceName - \(deviceName)")
             
              let deviceClass = VVToolUseClass.init()
              deviceClass.name = deviceName
              VVBleManager.shareInstance().connect(deviceClass)
              
              result(true)

          break;
          case "isDisconnect":

              var deviceName = ""
              let arg = call.arguments as! [String:Any]
              deviceName = arg["name"] as! String
             debugPrint("deviceName - \(deviceName)")
             
              let deviceClass = VVToolUseClass.init()
              deviceClass.name = deviceName
              VVBleManager.shareInstance().disconnect(.SpO2Device, withDeviceID: deviceName)
              result(true)
          break;
          case "clearMemory":
              
              var deviceName = ""
              let arg = call.arguments as! [String:Any]
              let deviceClass = VVToolUseClass.init()
              deviceClass.name = deviceName
              result(true)
          break;
          case "sync":
              self.jsonArray = [Any]();
              var deviceName = ""
              let arg = call.arguments as! [String:Any]
              deviceName = arg["name"] as! String
             debugPrint("deviceName - \(deviceName)")
             
              let deviceClass = VVToolUseClass.init()
              deviceClass.name = deviceName
              VVBleManager.shareInstance().connect(deviceClass)
              
              result(true);
          break;

          case "getDeviceData":
              let arg = call.arguments as! [String:Any]
              self.oximetryid = arg["oximetryid"] as! String
              self.studysession = arg["studysession"] as! String
              result(self.jsonArray)

          break;

          default:
              result(false)
          }
      });
      GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
   

    func scanECGDevice() -> Void {
        self.deviceList.removeAllObjects()
        print("scanECGDevice")
        let deviceClass = VVToolUseClass.init()
        deviceClass.scanTimeout = 60*1000

        VVBleManager.shareInstance().startScan(deviceClass, with: .SpO2Device)
    }

    
    func onReceiveData(_ Data: Any!) {
        let dict = Data as! Dictionary<String, Any>

        let pr = dict["pr"] as! Int
        let spo2 = dict["spo2"] as! Int
        let recordTime = dict["recordTime"] as! UInt64
        
        let date = NSDate(timeIntervalSince1970: TimeInterval(recordTime / 1000))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS'Z'"
        formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
      //  print(formatter.string(from: date as Date))
      //  print(date)

    
        print(pr)
        print(spo2)
        self.jsonArray=[Any]();

        var jDict = [String:Any]()
        jDict["pulserate"] = pr
        jDict["spo2"] = spo2
        jDict["datetime"] = formatter.string(from: date as Date)
        jDict["oximetryid"] = oximetryid
        jDict["studysession"] = studysession
        

        self.jsonArray.append(jDict)
        
        print("result data \(dict)")

    }

    func onDisconnected(_ device: VVToolUseClass!, isForce: Bool) {
        print("\(device.name!) disconnect ")

    }

    func onConnected(_ device: VVToolUseClass!) {
        VVBleManager.shareInstance().stopScan()
       print("Connect \(device.name!) Success")
        //VVConfigManager.switch(toFullDualMode: device.name)
        VVConfigManager.switch(toLiveMode:device.name)
    }

    func connect(onError code: Int32, msg: String!) {
        print("Connect Error:\(msg!)")
    }

    func onResume(_ deviceId: String!) -> Bool {

        return true
    }

    func onDeviceFound(_ device: VVToolUseClass!) {
        print("Device Found device name :\(device.name!)")

        self.deviceList.add(device.name!)

    }

    func onComplete(_ result: Any!) {
        let dict = result as! Dictionary<String,Any>
        print("CMD result \(dict)")
    }
}
