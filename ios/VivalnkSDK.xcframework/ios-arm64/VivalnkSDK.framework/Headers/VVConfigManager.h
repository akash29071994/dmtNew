//
//  VVConfigManager.h
//  VivalnkSDK
//
//  Created by 徐伟 on 2019/12/17.
//  Copyright © 2019 cyan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VVConfigManager : NSObject

/**
 * Perform baseline drift processing on the returned ECG so that the waveform is on a horizontal line
 * @param ecgArray ecg array data
 * @param deviceId Device number to be processed
 * @return Return processed data
 * @discussion Since the generated ecg data is a continuous data, there will be a drift phenomenon at the beginning due to the influence of the human electrode. This method is to pull the waveform down on the same horizontal line when drawing, so that the waveform will look better
 */
+ (NSArray *)getBaseLineDataToDraw:(NSArray *)ecgArray withDeviceId:(NSString *)deviceId;


+ (NSArray *)ecgSmoothECG:(NSArray *)ecgArray withTime:(NSTimeInterval)dataTime;

/**
 * Set the data to send to the cloud switch,need to be set before the device is connected
 * @param enable YES is to send data to the server, NO is not sent, the default is not to send
 */
+ (void)setDataToCloudEnable:(BOOL)enable withProjectID:(NSString *)projectId withSubjectID:(NSString *)subjectId;



/**
 * Start to upgrade ECG device firmware (OTA)
 * @param deviceId  devise serial number
 * @param progressPlx progress Returns the progress of the update
 * @param statePlx titleMsg Return updated header information，stateMsg Returns updated status information
 */
+ (void)startUpdateFirmware:(NSString *)deviceId withProgressState:(void(^)(float progress))progressPlx withOTAState:(void(^)(NSString *titleMsg,NSString *stateMsg))statePlx;

/**
 * Start uploading historical data
 * @param progressPlx progress:upload progress
 */
+ (void)startUploadHistoryData:(NSString *)deviceId withPlx:(void(^)(float progress,NSString *errorMsg))progressPlx;


/**
 * Whether to allow clock synchronization to be set after successful connection
 * @param enable YES means agree,NO means disagree,default YES
 * @discussion Clock synchronization only for EGG devices
 */
+ (void)setAllowAfterConnectedSyncClock:(BOOL)enable;


/**
 * APP focus on continuous and complete data stream.
 * The BLE connection between ECG patch and receiver can be ensured in most of time, e.g., in-door/ in-hospital use.
 * The ECG patch will go to traditional Holter mode if no BLE connection, and the data stored in patch cache will be uploaded to APP automatically when BLE connected.
 *
 * @param deviceId  devise serial number
 */
+ (void)switchToLiveMode:(NSString *)deviceId;

/**
 * APP focus on continuous and complete data stream, as well as real-time performance of the data.
 * APP to get the real-time data stream from Channel A, and the rest of data from Channel B, so Channel A data + Channel B data = complete data, no duplicate data.
 * Default configuration for BLE 4.1 patch (firmware version ＜ 2.0.0), the APP can be upgraded to support BLE 4.2 patch (firmware version ≥ 2.0.0) easily in this mode with minimum effort.
 *
 * @param deviceId  devise serial number
 */
+ (NSInteger)switchToDualMode:(NSString *)deviceId;

/**
 * APP focus on continuous and complete data stream, as well as real-time performance of the data.
 * APP to get the real-time data stream from Channel A, and continuous/complete data stream from Channel B.
 * There will be duplicate data on APP, removal is needed to consider.
 * In this mode, the ECG patch battery life will be minimum.
 *
 * @param deviceId  devise serial number
 */
+ (void)switchToFullDualMode:(NSString *)deviceId;

/**
 * APP focus on the real-time and continuous data stream only when BLE connected, for ECG waveform display and analysis etc. No requirement on the data during BLE disconnection.
 * In this mode, the ECG patch battery life will be maximum.
 *
 * @param deviceId  devise serial number
 */
+ (void)switchToRTSMode:(NSString *)deviceId;


/**
 Switch the sampling rate of ACC under lead off, no sampling by default
 切换lead off下ACC的采样率  默认不采样
 */
+ (void)switchACCSamplingInLeadOff:(NSString *)deviceId enable:(BOOL)enable;
/**
 *Switch the sampling rate of ACC under lead on, default sampling
 *切换lead on下ACC的采样率  默认采样
 */
+ (NSInteger)switchACCSamplingInLeadOn:(NSString *)deviceId enable:(BOOL)enable;


#pragma mark - Temperature module setting
/**
 * Set whether to enable background positioning
 * @param enable Yes means open, NO means close, default YES
 */
+ (void)setBackgroundLocation:(BOOL)enable;


/**
 * Set the frequency of scanning body temperature data, unit: S
 * @param timer Scanning time value, range 0.1~1, default value is 0.5 unit: S
 * @discussion The smaller the set value, the higher the acceptance rate in the background, otherwise, the lower the acceptance rate in the background. If you are not allowed to be in the background, you do not need to call this interface.
 */
+ (void)setScanTemperatureTimer:(float)timer;


/**
 * Set whether to agree with location information acquisition
 * @param enable YES means agree,NO means disagree,default YES
 * @discussion If positioning is not set or allowed, then this interface is invalid. Only when the positioning is agreed, then this interface is meaningful.
 */
+ (void)setIsAgreeGetLocationInfo:(BOOL)enable;



@end

NS_ASSUME_NONNULL_END
