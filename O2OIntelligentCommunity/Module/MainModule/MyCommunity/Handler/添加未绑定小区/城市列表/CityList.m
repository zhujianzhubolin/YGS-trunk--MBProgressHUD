//
//  CityList.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "CityList.h"

@implementation CityList

//获取城市列表
-(void)postCity:(CityListModel *)cityM success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSDictionary *Dict = [NSDictionary dictionaryWithObjectsAndKeys:cityM.cityid,@"cityid",cityM.hot,@"hot", nil];
    NSLog(@"%@",Dict);
    
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:XQCitylist] requestType:ZJHttpRequestPost parameters:Dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic])
        {
            NSLog(@"response dic = %@",dic);
            if (success) {
                CityListModel *cityM=[self cityJson:dic];
                if (![NSString isEmptyOrNull:cityM.code] && [cityM.code isEqualToString:@"success"] && cityM.list.count > 0) {
                    success(cityM.list);
                    NSLog(@"%@",cityM.list);
//                    success([self decodeGetAllCity:cityM.list]);
                    return;
                }
            }
        }
        //NSLog(@"response dic = %@",dic);
        failed(nil);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
    }];
}

-(CityListModel *)cityJson:(NSDictionary *)dicJson
{
    CityListModel *cityM =[CityListModel new];
    cityM.cityid=dicJson[@"cityid"];
    cityM.hot=dicJson[@"hot"];
    cityM.code=dicJson[@"code"];
    
    if (![NSArray isArrEmptyOrNull:dicJson[@"list"]])
    {
        NSMutableArray *arr =[NSMutableArray array];
        [dicJson[@"list"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *recvDic = (NSDictionary *)obj;
            
            CityListModel *cityM =[CityListModel new];
            cityM.areacode    =recvDic[@"areacode"];
            cityM.areaname    =recvDic[@"areaname"];
            cityM.cityid      =recvDic[@"cityid"];
            cityM.hot         =recvDic[@"hot"];
            cityM.ID          =recvDic[@"id"];
            cityM.spell       =recvDic[@"spell"];
        
            [arr addObject:cityM];
        }];
        cityM.list =[arr copy];
    }
    return cityM;
    
}

+ (NSMutableDictionary *)decodeGetAllCity:(NSArray *)list {
    
        NSMutableDictionary *indexDic = [[NSMutableDictionary alloc] init];

        NSMutableArray *Aarray = [[NSMutableArray alloc] init];
        NSMutableArray *Barray = [[NSMutableArray alloc] init];
        NSMutableArray *Carray = [[NSMutableArray alloc] init];
        NSMutableArray *Darray = [[NSMutableArray alloc] init];
        NSMutableArray *Earray = [[NSMutableArray alloc] init];
        NSMutableArray *Farray = [[NSMutableArray alloc] init];
        NSMutableArray *Garray = [[NSMutableArray alloc] init];
        NSMutableArray *Harray = [[NSMutableArray alloc] init];

        NSMutableArray *Iarray = [[NSMutableArray alloc] init];
        NSMutableArray *Jarray = [[NSMutableArray alloc] init];
        NSMutableArray *Karray = [[NSMutableArray alloc] init];
        NSMutableArray *Larray = [[NSMutableArray alloc] init];
        NSMutableArray *Marray = [[NSMutableArray alloc] init];
        NSMutableArray *Narray = [[NSMutableArray alloc] init];
        NSMutableArray *Oarray = [[NSMutableArray alloc] init];
        NSMutableArray *Parray = [[NSMutableArray alloc] init];

        NSMutableArray *Qarray = [[NSMutableArray alloc] init];
        NSMutableArray *Rarray = [[NSMutableArray alloc] init];
        NSMutableArray *Sarray = [[NSMutableArray alloc] init];
        NSMutableArray *Tarray = [[NSMutableArray alloc] init];
        NSMutableArray *Uarray = [[NSMutableArray alloc] init];
        NSMutableArray *Varray = [[NSMutableArray alloc] init];
        NSMutableArray *Warray = [[NSMutableArray alloc] init];
        NSMutableArray *Xarray = [[NSMutableArray alloc] init];
        NSMutableArray *Yarray = [[NSMutableArray alloc] init];
        NSMutableArray *Zarray = [[NSMutableArray alloc] init];


        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CityListModel *cityM = (CityListModel *)obj;

            if ([cityM.areacode compare:@"A"]==0)
            {
                [Aarray addObject:cityM];
            }
            else if ([cityM.areacode compare:@"B"]==0)
            {
                [Barray addObject:cityM];
            }
            else if ([cityM.areacode compare:@"C"]==0)
            {
                [Carray addObject:cityM];
            }
            else if ([cityM.areacode compare:@"D"]==0)
            {
                [Darray addObject:cityM];
            }

            else if ([cityM.areacode compare:@"E"]==0)
            {
                [Earray addObject:cityM];
            }

            else if ([cityM.areacode compare:@"F"]==0)
            {
                [Farray addObject:cityM];
            }
            else if ([cityM.areacode compare:@"G"]==0)
            {
                [Garray addObject:cityM];
            }
            else if ([cityM.areacode compare:@"H"]==0)
            {
                [Harray addObject:cityM];
            }
            else if ([cityM.areacode compare:@"I"]==0)
            {
                [Iarray addObject:cityM];
            }
            else if ([cityM.areacode compare:@"J"]==0)
            {
                [Jarray addObject:cityM];
            }

            else if ([cityM.areacode compare:@"K"]==0)
            {
                [Karray addObject:cityM];
            }

            else if ([cityM.areacode compare:@"L"]==0)
            {
                [Larray addObject:cityM];
            }

            else if ([cityM.areacode compare:@"M"]==0)
            {
                [Marray addObject:cityM];
            }

            else if ([cityM.areacode compare:@"N"]==0)
            {
                [Narray addObject:cityM];
            }

            else if ([cityM.areacode compare:@"O"]==0)
            {
                [Oarray addObject:cityM];
            }

            else if ([cityM.areacode compare:@"P"]==0)
            {
                [Parray addObject:cityM];
            }
            else if ([cityM.areacode compare:@"Q"]==0)
            {
                [Qarray addObject:cityM];
            }
            else if ([cityM.areacode compare:@"R"]==0)
            {
                [Rarray addObject:cityM];
            }
            else if ([cityM.areacode compare:@"S"]==0)
            {
                [Sarray addObject:cityM];
            }

            else if ([cityM.areacode compare:@"T"]==0)
            {
                [Tarray addObject:cityM];
            }

            else if ([cityM.areacode compare:@"U"]==0)
            {
                [Uarray addObject:cityM];
            }

            else if ([cityM.areacode compare:@"V"]==0)
            {
                [Varray addObject:cityM];
            }

            else if ([cityM.areacode compare:@"W"]==0)
            {
                [Warray addObject:cityM];
            }

            else if ([cityM.areacode compare:@"X"]==0)
            {
                [Xarray addObject:cityM];
            }

            else if ([cityM.areacode compare:@"Y"]==0)
            {
                [Yarray addObject:cityM];
            }

            else if ([cityM.areacode compare:@"Z"]==0)
            {
                [Zarray addObject:cityM];
            }

        }];
        if ([Aarray count]> 0)
        {
            [indexDic setObject:Aarray forKey:@"A"];
        }
        if ([Barray count]> 0)
        {
            [indexDic setObject:Barray forKey:@"B"];
        }
        if ([Carray count]> 0)
        {
            [indexDic setObject:Carray forKey:@"C"];
        }
        if ([Darray count]> 0)
        {
            [indexDic setObject:Darray forKey:@"D"];
        }
        if ([Earray count]> 0)
        {
            [indexDic setObject:Earray forKey:@"E"];
        }

        if ([Farray count]> 0)
        {
            [indexDic setObject:Farray forKey:@"F"];
        }

        if ([Garray count]> 0)
        {
            [indexDic setObject:Garray forKey:@"G"];
        }

        if ([Harray count]> 0)
        {
            [indexDic setObject:Harray forKey:@"H"];
        }

        if ([Iarray count]> 0)
        {
            [indexDic setObject:Iarray forKey:@"I"];
        }

        if ([Jarray count]> 0)
        {
            [indexDic setObject:Jarray forKey:@"J"];
        }

        if ([Karray count]> 0)
        {
            [indexDic setObject:Karray forKey:@"K"];
        }

        if ([Larray count]> 0)
        {
            [indexDic setObject:Larray forKey:@"L"];
        }

        if ([Marray count]> 0)
        {
            [indexDic setObject:Marray forKey:@"M"];
        }

        if ([Narray count]> 0)
        {
            [indexDic setObject:Narray forKey:@"N"];
        }

        if ([Oarray count]> 0)
        {
            [indexDic setObject:Oarray forKey:@"O"];
        }


        if ([Parray count]> 0)
        {
            [indexDic setObject:Parray forKey:@"P"];
        }

        if ([Qarray count]> 0)
        {
            [indexDic setObject:Qarray forKey:@"Q"];
        }

        if ([Rarray count]> 0)
        {
            [indexDic setObject:Rarray forKey:@"R"];
        }

        if ([Sarray count]> 0)
        {
            [indexDic setObject:Sarray forKey:@"S"];
        }

        if ([Tarray count]> 0)
        {
            [indexDic setObject:Tarray forKey:@"T"];
        }

        if ([Uarray count]> 0)
        {
            [indexDic setObject:Uarray forKey:@"U"];
        }

        if ([Varray count]> 0)
        {
            [indexDic setObject:Varray forKey:@"V"];
        }

        if ([Warray count]> 0)
        {
            [indexDic setObject:Warray forKey:@"W"];
        }

        if ([Xarray count]> 0)
        {
            [indexDic setObject:Xarray forKey:@"X"];
        }

        if ([Yarray count]> 0)
        {
            [indexDic setObject:Yarray forKey:@"Y"];
        }

        if ([Zarray count]> 0)
        {
            [indexDic setObject:Zarray forKey:@"Z"];
        }

        NSLog(@"%@",indexDic);

    return indexDic;
}


+ (NSMutableArray *)hotgetAllCity:(NSArray *)list
{
    NSMutableArray *arr =[[NSMutableArray alloc]init];
    [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CityListModel *cityM = (CityListModel *)obj;
        NSLog(@" cityM.hot %@",cityM.hot);
        
        if (![cityM.hot isEqual:[NSNull null]])
        {
            NSString *cityStr =cityM.hot;
            if ([cityStr isEqualToString:@"Y"])
            {
                [arr addObject:cityM];
            }
            
        }
    }];
    
    return arr;

}




@end
