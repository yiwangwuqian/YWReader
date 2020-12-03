//
//  LSYReadUtilites.m
//  LSYReader
//
//  Created by Labanotation on 16/5/31.
//  Copyright © 2016年 okwei. All rights reserved.
//

#define kDocuments NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject

#import "LSYReadUtilites.h"
#import "LSYChapterModel.h"
#import "ZipArchive.h"
#import "TouchXML.h"

@implementation LSYReadUtilites
#pragma mark - ePub处理
+(NSMutableArray *)ePubFileHandle:(NSString *)path;
{
    NSString *ePubPath = [self unZip:path];
    if (!ePubPath) {
        return nil;
    }
    NSString *OPFPath = [self OPFPath:ePubPath];
    return [self parseOPF:OPFPath];
    
}
#pragma mark - 解压文件路径
+(NSString *)unZip:(NSString *)path
{
    NSString *zipFile = [[path stringByDeletingPathExtension] lastPathComponent];
    
    NSString *zipPath = [NSString stringWithFormat:@"%@/%@",kDocuments,zipFile];
    NSFileManager *filemanager=[[NSFileManager alloc] init];
    if ([filemanager fileExistsAtPath:zipPath]) {
        NSError *error;
        [filemanager removeItemAtPath:zipPath error:&error];
    }
    if ([SSZipArchive unzipFileAtPath:path toDestination:[NSString stringWithFormat:@"%@/",zipPath]]) {
        return zipFile;
    }
    
    return nil;
}
#pragma mark - OPF文件路径
+(NSString *)OPFPath:(NSString *)epubPath
{

    NSString *containerPath = [NSString stringWithFormat:@"%@/%@/META-INF/container.xml",kDocuments,epubPath];
    //container.xml文件路径 通过container.xml获取到opf文件的路径
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:containerPath]) {
        CXMLDocument* document = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:containerPath] options:0 error:nil];
        CXMLNode* opfPath = [document nodeForXPath:@"//@full-path" error:nil];
        // xml文件中获取full-path属性的节点  full-path的属性值就是opf文件的绝对路径
        NSString *path = [NSString stringWithFormat:@"%@/%@",epubPath,[opfPath stringValue]];
        return path;
    } else {
        NSLog(@"ERROR: ePub not Valid");
        return nil;
    }

}

#pragma mark - 解析OPF文件
+(NSMutableArray *)parseOPF:(NSString *)opfPath
{
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@",kDocuments,opfPath];
    CXMLDocument* document = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:fullPath] options:0 error:nil];
    NSArray* itemsArray = [document nodesForXPath:@"//opf:item" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];
    //opf文件的命名空间 xmlns="http://www.idpf.org/2007/opf" 需要取到某个节点设置命名空间的键为opf 用opf:节点来获取节点
    NSString *ncxFile;
    NSMutableDictionary* itemDictionary = [[NSMutableDictionary alloc] init];
    for (CXMLElement* element in itemsArray){
        [itemDictionary setValue:[[element attributeForName:@"href"] stringValue] forKey:[[element attributeForName:@"id"] stringValue]];
        if([[[element attributeForName:@"media-type"] stringValue] isEqualToString:@"application/x-dtbncx+xml"]){
            ncxFile = [[element attributeForName:@"href"] stringValue]; //获取ncx文件名称 根据ncx获取书的目录
            
        }
    }
    
    NSString *absolutePath = [fullPath stringByDeletingLastPathComponent];
    CXMLDocument *ncxDoc = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", absolutePath,ncxFile]] options:0 error:nil];
    NSMutableDictionary* titleDictionary = [[NSMutableDictionary alloc] init];
    for (CXMLElement* element in itemsArray) {
        NSString* href = [[element attributeForName:@"href"] stringValue];
        
        NSString* xpath = [NSString stringWithFormat:@"//ncx:content[@src='%@']/../ncx:navLabel/ncx:text", href];
        //根据opf文件的href获取到ncx文件中的中对应的目录名称
        NSArray* navPoints = [ncxDoc nodesForXPath:xpath namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.daisy.org/z3986/2005/ncx/" forKey:@"ncx"] error:nil];
        if ([navPoints count] == 0) {
            NSString *contentpath = @"//ncx:content";
            NSArray *contents = [ncxDoc nodesForXPath:contentpath namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.daisy.org/z3986/2005/ncx/" forKey:@"ncx"] error:nil];
            for (CXMLElement *element in contents) {
                NSString *src = [[element attributeForName:@"src"] stringValue];
                if ([src hasPrefix:href]) {
                    xpath = [NSString stringWithFormat:@"//ncx:content[@src='%@']/../ncx:navLabel/ncx:text", src];
                    navPoints = [ncxDoc nodesForXPath:xpath namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.daisy.org/z3986/2005/ncx/" forKey:@"ncx"] error:nil];
                    break;
                }
            }
        }
        
        if([navPoints count]!=0){
            CXMLElement* titleElement = navPoints.firstObject;
            [titleDictionary setValue:[titleElement stringValue] forKey:href];
        }
    }
    NSArray* itemRefsArray = [document nodesForXPath:@"//opf:itemref" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];
    NSMutableArray *chapters = [NSMutableArray array];
    for (CXMLElement* element in itemRefsArray){
        NSString* chapHref = [itemDictionary objectForKey:[[element attributeForName:@"idref"] stringValue]];

        NSString *path = [[opfPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:chapHref];
        LSYChapterModel *model = [LSYChapterModel chapterWithEpub:path title:[titleDictionary objectForKey:chapHref]];
        [chapters addObject:model];
        
    }
    return chapters;
}
@end
