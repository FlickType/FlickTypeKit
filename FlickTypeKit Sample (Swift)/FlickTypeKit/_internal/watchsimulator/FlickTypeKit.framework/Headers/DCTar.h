////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  DCTar.h
//
//  Created by Dalton Cherry on 5/21/14.
//
////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 Discussion.
 It is important to know that all the file system based tar commands used chunked/buffer methods to save memory.
 Due to the fact that tars are normally used to compress lots of content, It is strongly recommend to use those method
 versus the in memory data options.
 */
#import <Foundation/Foundation.h>

@interface DCTar : NSObject

/**
 Create a gzipped tar file from a file or directory.
 filePath is the path to file on disk.
 toPath is the path to create the tar at.
 error is used to report back if an error happened.
 @return if the compression was successful or not.
 */
+(BOOL)compressFileAtPath:(NSString*)filePath toPath:(NSString*)toPath error:(NSError**)error;

/**
 Create a gzipped tar file from a data blob.
 data is the file data blob to create a tar with.
 toPath is the path to create the tar at.
 error is used to report back if an error happened.
 @return if the compression was successful or not.
 */
//+(BOOL)compressData:(NSData*)data toPath:(NSString*)path error:(NSError**)error;

/**
 decompress a tar or gzipped tar (.tar or tar.giz) file.
 filePath is the path to the tar file on disk.
 toPath is the directory path to create the export data at.
 error is used to report back if an error happened.
 @return if the decompression was successful or not.
 */
+(BOOL)decompressFileAtPath:(NSString*)filePath toPath:(NSString*)path error:(NSError**)error;

/**
 decompress a tar or gzipped tar (.tar or tar.giz) file.
 data is the file tar blob to decompress.
 toPath is the directory path to create the export data at.
 error is used to report back if an error happened.
 @return if the decompression was successful or not.
 */
+(BOOL)decompressData:(NSData*)data toPath:(NSString*)path error:(NSError**)error;

/**
 Create a tar file (no gzipping) from a file or directory.
 filePath is the path to file on disk.
 toPath is the path to create the tar at.
 error is used to report back if an error happened.
 @return if the compression was successful or not.
 */
+(BOOL)tarFileAtPath:(NSString*)tarFilePath toPath:(NSString*)path error:(NSError**)error;

/**
 decompress a tar file.
 filePath is the path to the tar file on disk.
 toPath is the directory path to create the export data at.
 error is used to report back if an error happened.
 @return if the decompression was successful or not.
 */
+(BOOL)untarFileAtPath:(NSString*)tarFilePath toPath:(NSString*)path error:(NSError**)error;

/**
 Get the table of contents with file names, offsets, and sizes.
 error is used to report back if an error happened.
 @return (filename) -> [offset, size]
 */
+(NSDictionary<NSString*, NSArray<NSNumber*>*>*) entriesFor:(id)tarObject size:(unsigned long long)size error:(NSError**)error;

/**
 Create a tar file (not gzipped) from a data blob.
 data is the file data blob to create a tar with.
 toPath is the path to create the tar at.
 error is used to report back if an error happened.
 @return if the compression was successful or not.
 */
//+(BOOL)tarData:(NSData*)tarData toPath:(NSString*)path error:(NSError**)error;

/**
 decompress a tar file (not gzipped).
 data is the file tar blob to decompress.
 toPath is the directory path to create the export data at.
 error is used to report back if an error happened.
 @return if the decompression was successful or not.
 */
+(BOOL)untarData:(NSData*)tarData toPath:(NSString*)path error:(NSError**)error;

/**
 gzipped some data.
 The data to gzip.
 @return The newly gzipped data.
 */
+(NSData*)gzipCompress:(NSData*)data;

/**
 decompress a gzipped data blob.
 The data to ungzip.
 @return The newly unzipped data.
 */
+(NSData*)gzipDecompress:(NSData*)data;

/**
 decompress a gzipped file.
 filePath is the path to file on disk.
 toPath is the path to create the tar at.
 error is used to report back if an error happened.
 @return if the compression was successful or not.
 */
+(BOOL)gzipDecompress:(NSString*)filePath toPath:(NSString*)toPath error:(NSError**)error;

/**
 decompress a zlib data blob.
 The data to decompress.
 @return The newly decompressed data.
 */
+(NSData*)zlibDecompress:(NSData*)data;

/**
 compress a zlib data blob.
 The data to compress.
 @return The newly compressed data.
 */
+(NSData*)zlibCompress:(NSData*)data;

@end
