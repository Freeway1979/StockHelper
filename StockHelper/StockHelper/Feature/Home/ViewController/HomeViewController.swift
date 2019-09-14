//
//  HomeViewController.swift
//  StockHelper
//
//  Created by Andy Liu on 2018/12/22.
//  Copyright © 2018 Andy Liu. All rights reserved.
//

import UIKit
import ZKProgressHUD

private let reuseIdentifier = "Cell"

fileprivate let tagReuseIdentifier = "TagCollectionViewCell"
fileprivate let headerReuseIdentifier = "HeaderCollectionView"
fileprivate let columns = 4
fileprivate let sectionInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)


class HomeViewController: UICollectionViewController {
    enum SectionType:Int {
        case QuickActions = 0
        case BlockPeriod
        case HotBlocks
        case HotStocks
        case Xuangu
        case WebSite
        func description() -> String {
            switch self {
            case .QuickActions: return "快捷方式"
            case .BlockPeriod: return "板块淘金"
            case .HotBlocks: return "人气板块"
            case .HotStocks: return "人气股票"
            case .Xuangu: return "智能选股"
            case .WebSite: return "常用网站"
            }
        }
    }
    private struct ItemData {
        var title: String = ""
        var data: String? = ""
        var onItemClicked : (_ item:ItemData) -> Void
    }
    
    private class LayoutData {
        var title:String = ""
        var data: [ItemData] = []
        init(title:String,data:[ItemData]) {
            self.title = title
            self.data = data
        }
    }
    
    private var layoutData:[LayoutData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Register cell classes
        self.collectionView.register(UINib(nibName:tagReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: tagReuseIdentifier)
        self.collectionView.register(UINib(nibName: headerReuseIdentifier,bundle:nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        
        
        self.setupLayoutData()
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView!.delegate = self;
        // Do any additional setup after loading the view.
        loadData()
        
        let json = "{[\"000001.SZ\",\"平安银行\",\"14.44\",\"0.979\",<a href=\"tel:15403000000,67829000000\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"41\">15403000000,67829000000</a>,\"15.1885\",\"247938350000.000\"],[\"000553.SZ\",\"安道麦A\",\"9.50\",\"1.387\",<a href=\"tel:588638000,13616032000\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"69\">588638000,13616032000</a>,\"-75.3622\",<a href=\"tel:4451858669\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"70\">4451858669</a>],[\"000002.SZ\",\"万科A\",\"26.70\",\"3.891\",11841752171.43,139320076841.32999,\"29.7905\",\"259395040000.000\"],[\"000005.SZ\",\"世纪星源\",\"3.83\",\"10.058\",62234817.520000003,424134990.98000002,\"<a href=\"tel:663.9275\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"42\">663.9275</a>\",\"4051934100.000\"],[\"000006.SZ\",\"深振业A\",\"5.64\",\"3.486\",203409521.11000001,953510762.07000005,\"-51.0998\",\"7604457000.000\"],[\"000008.SZ\",\"神州高铁\",\"3.64\",\"1.961\",66213204.770000003,932616832.89999998,\"7.8739\",\"9441326000.000\"],[\"000009.SZ\",\"中国宝安\",\"4.88\",\"2.306\",138075594.69999999,5891655023.5,\"20.16\",\"12413924000.000\"],[\"000011.SZ\",\"深物业A\",\"11.10\",\"6.322\",103749398.16,755390079.96000004,\"25.0407\",\"5843512500.000\"],[\"000012.SZ\",\"南玻A\",\"4.30\",\"0.703\",<a href=\"tel:377342401,4888237578\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"43\">377342401,4888237578</a>,\"6.9452\",\"8402498700.000\"],[\"000016.SZ\",\"深康佳A\",\"4.54\",\"1.339\",352767020.73000002,26036442813.84,\"3.2107\",\"7248447300.000\"],[\"000019.SZ\",\"深粮控股\",\"6.98\",\"3.102\",203168850.61000001,4782167732.6899996,\"0.1921\",\"2903124400.000\"],[\"000021.SZ\",\"深科技\",\"12.62\",\"2.769\",149620968.94,6466509240.29,\"-12.8988\",\"18542908000.000\"],[\"000023.SZ\",\"深天地A\",\"15.39\",\"5.411\",31104062.41,831865692.12,\"3498.0235\",\"2135458500.000\"],[\"000025.SZ\",\"特力A\",\"22.94\",\"5.037\",44779948.600000001,278268739.32999998,\"66.3428\",\"9010334700.000\"],[\"000026.SZ\",\"飞亚达A\",\"8.30\",\"1.467\",123495460.90000001,1785036020.23,\"9.9028\",\"2960745900.000\"],[\"000027.SZ\",\"深圳能源\",\"6.13\",\"3.547\",1032242134.41,10386152060.23,\"92.2107\",\"24302333000.000\"],[\"000028.SZ\",\"国药一致\",\"46.84\",\"-0.552\",650833360.39999998,25228147377.43,\"1.419\",\"14414746000.000\"],[\"000029.SZ\",\"深深房A\",\"--\",\"--\",333155843.41000003,1251337802.5699999,\"1.2428\",\"9781510200.000\"],[\"000030.SZ\",\"富奥股份\",\"4.61\",\"0.217\",423754627.42000002,4583499013.7299995,\"-11.9771\",\"8113050800.000\"],[\"000031.SZ\",\"大悦城\",\"6.60\",\"3.125\",1931621336.78,18270846528.34,\"41.9706\",\"11970571500.000\"],[\"000032.SZ\",\"深桑达A\",\"13.62\",\"10.016\",52282579.530000001,658153144.24000001,\"-13.4978\",\"5601683400.000\"],[\"000034.SZ\",\"神州数码\",\"15.54\",\"3.808\",396512648.79000002,42335767305.410004,\"48.2294\",\"7544296100.000\"],[\"000035.SZ\",\"中国天楹\",\"5.73\",\"-1.036\",211703083.66,8043733364.8599997,\"<a href=\"tel:142.6232\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"44\">142.6232</a>\",\"7340642800.000\"],[\"000036.SZ\",\"华联控股\",\"4.56\",\"2.013\",458949925.39999998,1655768950.3399999,\"20.6577\",\"6726106300.000\"],[\"000039.SZ\",\"中集集团\",\"10.09\",\"0.799\",<a href=\"tel:679829000,42717729000\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"45\">679829000,42717729000</a>,\"-29.5804\",\"15356160000.000\"],[\"000040.SZ\",\"东旭蓝天\",\"5.39\",\"1.890\",92708552.719999999,5232670823.4499998,\"-92.9628\",\"5715236200.000\"],[\"000042.SZ\",\"中洲控股\",\"9.77\",\"2.090\",202102536.81999999,2389802552.0900002,\"-71.8544\",\"6469718100.000\"],[\"000043.SZ\",\"中航善达\",\"15.78\",\"-1.988\",84806691.030000001,2580418763.02,\"-32.6085\",\"10522000100.000\"],[\"000046.SZ\",\"泛海控股\",\"4.60\",\"3.139\",1737461871.23,1192648533.79,\"30.2813\",\"23804837000.000\"],[\"000048.SZ\",\"*ST康达\",\"22.93\",\"-1.036\",149692595.47999999,1171741047.1500001,\"<a href=\"tel:465.3387\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"46\">465.3387</a>\",\"8958921800.000\"],[\"000049.SZ\",\"德赛电池\",\"38.22\",\"-1.899\",170319218.86000001,7328459850.6400003,\"27.7041\",\"7844415700.000\"],[\"000050.SZ\",\"深天马A\",\"14.57\",\"-0.342\",643588028.73000002,14595066823.719999,\"-17.6792\",\"26646455000.000\"],[\"000055.SZ\",\"方大集团\",\"5.20\",\"0.386\",128581755.01000001,1425890946.99,\"-44.1269\",\"3527076300.000\"],[\"000056.SZ\",\"皇庭国际\",\"5.98\",\"-3.548\",90113206.900000006,485332471.26999998,\"6.2175\",\"5404324600.000\"],[\"000058.SZ\",\"深赛格\",\"10.46\",\"2.049\",83287552.019999996,765491685.13999999,\"-14.7229\",\"5627894200.000\"],[\"000059.SZ\",\"华锦股份\",\"5.85\",\"0.343\",538207007.57000005,18328682761.119999,\"-29.4354\",\"9356718600.000\"],[\"000060.SZ\",\"中金岭南\",\"4.29\",\"2.387\",470584665.06,9272716016.1700001,\"-22.434\",\"15307740000.000\"],[\"000061.SZ\",\"农产品\",\"5.54\",\"1.465\",91701282.200000003,1344099243.1400001,\"<a href=\"tel:620.7927\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"47\">620.7927</a>\",\"9392605900.000\"],[\"000062.SZ\",\"深圳华强\",\"14.66\",\"1.383\",342291100.67000002,5916012581.8800001,\"-4.7919\",\"15314496000.000\"],[\"000063.SZ\",\"中兴通讯\",\"29.60\",\"-0.771\",<a href=\"tel:1470699000,44609219000\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"48\">1470699000,44609219000</a>,\"<a href=\"tel:118.7968\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"49\">118.7968</a>\",\"102361051000.000\"],[\"000065.SZ\",\"北方国际\",\"9.50\",\"-0.105\",360791456.66000003,3818092472.9000001,\"5.4378\",\"5974964300.000\"],[\"000066.SZ\",\"中国长城\",\"12.61\",\"-0.158\",143392145.31999999,4330232835.1499996,\"-42.8199\",\"31407756000.000\"],[\"000069.SZ\",\"华侨城A\",\"7.23\",\"1.261\",2809665596.27,17654104160.09,\"39.5217\",\"50730596000.000\"],[\"000070.SZ\",\"特发信息\",\"13.27\",\"-2.139\",67004361.039999999,2133324381.1900001,\"-31.3054\",\"10320374000.000\"],[\"000078.SZ\",\"海王生物\",\"3.52\",\"0.860\",203765630.50999999,20850804944.34,\"-37.6414\",\"9229302000.000\"],[\"000088.SZ\",\"盐田港\",\"6.34\",\"3.257\",122346667.8,285102690.56,\"-28.6126\",\"12313548000.000\"],[\"000089.SZ\",\"深圳机场\",\"10.75\",\"1.320\",307789768.91000003,1857178331.1800001,\"-16.7038\",\"22045772000.000\"],[\"000090.SZ\",\"天健集团\",\"5.67\",\"1.978\",240515517.44999999,3923890960.6900001,\"17.7271\",\"10593916900.000\"],[\"000096.SZ\",\"广聚能源\",\"10.34\",\"1.572\",35498544.700000003,797401158.23000002,\"-55.9634\",\"5282168300.000\"],[\"000099.SZ\",\"中信海直\",\"8.02\",\"-0.865\",90806320.719999999,753162986.01999998,\"112.2918\",\"4860684800.000\"],[\"000100.SZ\",\"TCL集团\",\"3.32\",\"1.220\",<a href=\"tel:2092349000,43781614000\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"51\">2092349000,43781614000</a>,\"31.9312\",\"42030629000.000\"],[\"000153.SZ\",\"丰原药业\",\"6.35\",\"0.794\",56566642.630000003,1567862608.4300001,\"48.5424\",\"1981055400.000\"],[\"000155.SZ\",\"川能动力\",\"4.00\",\"-0.249\",230015250.46000001,970660402.95000005,\"<a href=\"tel:608.9144\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"52\">608.9144</a>\",\"5080000000.000\"],[\"000156.SZ\",\"华数传媒\",\"10.03\",\"-1.085\",404652587.19,1650469175.6600001,\"27.6841\",\"12841362200.000\"],[\"000157.SZ\",\"中联重科\",\"5.84\",\"0.864\",2576288984.2399998,22262105264.98,\"<a href=\"tel:198.1064\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"53\">198.1064</a>\",\"36969281000.000\"],[\"000158.SZ\",\"常山北明\",\"5.33\",\"0.947\",30078504.960000001,4356736034.3299999,\"0.2822\",\"8657149000.000\"],[\"000166.SZ\",\"申万宏源\",\"4.93\",\"0.818\",3201520942.5700002,10484456561.43,\"54.9949\",\"111094662000.000\"],[\"000301.SZ\",\"东方盛虹\",\"5.35\",\"1.326\",796246015.94000006,12297357334.790001,\"10.8375\",\"6517565000.000\"],[\"000333.SZ\",\"美的集团\",\"54.45\",\"0.258\",<a href=\"tel:15187069000,153770300000\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"54\">15187069000,153770300000</a>,\"17.3939\",\"369483060000.000\"],[\"000338.SZ\",\"潍柴动力\",\"11.62\",\"1.044\",5287488377.8900003,90862496520.479996,\"20.373\",\"49327315000.000\"],[\"000400.SZ\",\"许继电气\",\"8.92\",\"2.060\",173522982.59,3054487770.4899998,\"31.4769\",\"8992968300.000\"],[\"000401.SZ\",\"冀东水泥\",\"16.92\",\"5.552\",1479628879.6800001,16078144786.129999,\"60.8237\",\"22794871000.000\"],[\"000402.SZ\",\"金融街\",\"7.59\",\"2.429\",1052641785.39,9518423212.6800003,\"21.6968\",\"22676123000.000\"],[\"000403.SZ\",\"振兴生化\",\"31.85\",\"-0.531\",77563427.969999999,401805328.58999997,\"16.264\",\"8644220600.000\"],[\"000404.SZ\",\"长虹华意\",\"4.06\",\"0.495\",47875840.950000003,4595301162.9200001,\"-20.5598\",\"2820168600.000\"],[\"000407.SZ\",\"胜利股份\",\"3.59\",\"1.127\",85218473.799999997,2968819358.23,\"18.3508\",\"3143920300.000\"],[\"000408.SZ\",\"藏格控股\",\"8.53\",\"0.000\",234247086.68000001,806725956.14999998,\"-45.8046\",\"3962028900.000\"],[\"000411.SZ\",\"英特集团\",\"13.30\",\"0.000\",97336813.739999995,11798893168.799999,\"95.2828\",\"2757317000.000\"],[\"000413.SZ\",\"东旭光电\",\"4.98\",\"4.622\",844176169.98000002,8475089222.9300003,\"-1.6451\",\"24223493000.000\"],[\"000415.SZ\",\"渤海租赁\",\"3.74\",\"0.809\",<a href=\"tel:1806675000,18926160000\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"55\">1806675000,18926160000</a>,\"40.0781\",\"13267263300.000\"],[\"000417.SZ\",\"合肥百货\",\"4.59\",\"0.879\",136575159.28999999,5963336837.54,\"-16.5625\",\"3575736000.000\"],[\"000419.SZ\",\"通程控股\",\"4.37\",\"0.691\",73493776.129999995,1774126345.5899999,\"-9.3993\",\"2374177200.000\"],[\"000420.SZ\",\"吉林化纤\",\"2.43\",\"1.250\",70755875.859999999,1317221983.6700001,\"-10.1818\",\"4496667700.000\"],[\"000421.SZ\",\"南京公用\",\"4.48\",\"0.224\",57050763.369999997,1962195185.6300001,\"-34.3969\",\"2565458300.000\"],[\"000422.SZ\",\"ST宜化\",\"2.75\",\"0.365\",50378946.659999996,7220822516.4499998,\"-78.8514\",\"2468985700.000\"],[\"000423.SZ\",\"东阿阿胶\",\"31.64\",\"0.764\",192963719.27000001,1890344562.1300001,\"-77.621\",\"20688362000.000\"],[\"000425.SZ\",\"徐工机械\",\"4.55\",\"2.478\",2283307031.9499998,31156145145.889999,\"<a href=\"tel:106.8156\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"56\">106.8156</a>\",\"31822586000.000\"],[\"000429.SZ\",\"粤高速A\",\"7.55\",\"0.667\",736486112.29999995,1483673245.21,\"-5.4578\",\"9835934600.000\"],[\"000488.SZ\",\"晨鸣纸业\",\"4.71\",\"0.213\",509795572.29000002,13348648113.700001,\"-71.4341\",\"7802228100.000\"],[\"000498.SZ\",\"山东路桥\",\"4.97\",\"2.263\",173706672.78,8956999983.5499992,\"28.8441\",\"5566799200.000\"],[\"000501.SZ\",\"鄂武商A\",\"10.34\",\"0.291\",599886909.85000002,8875002410.1299992,\"4.0643\",\"7938610000.000\"],[\"000505.SZ\",\"京粮控股\",\"6.00\",\"-0.166\",51510904.409999996,3283277725.3899999,\"-14.0324\",\"2436766800.000\"],[\"000507.SZ\",\"珠海港\",\"5.72\",\"0.882\",121539155.22,1492176639.3599999,\"1.4992\",\"4416662400.000\"],[\"000510.SZ\",\"新金路\",\"4.19\",\"1.453\",45551288.469999999,1132714983.1400001,\"-37.926\",\"2302317700.000\"],[\"000513.SZ\",\"丽珠集团\",\"28.26\",\"-0.738\",738947763.69000006,4939065593.9399996,\"16.6721\",\"16813814000.000\"],[\"000517.SZ\",\"荣安地产\",\"2.94\",\"10.112\",592046126.12,2061587885.05,\"<a href=\"tel:239.1629\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"57\">239.1629</a>\",\"8924979500.000\"],[\"000519.SZ\",\"中兵红箭\",\"10.02\",\"-1.861\",161331245.00999999,2204965858.4899998,\"3.8651\",\"9345128600.000\"],[\"000520.SZ\",\"长航凤凰\",\"4.22\",\"1.442\",23552052.670000002,396138740.55000001,\"-54.0576\",\"4270992200.000\"],[\"000521.SZ\",\"长虹美菱\",\"3.42\",\"0.885\",54334022.57,9133162680.9400005,\"7.201\",\"2743567700.000\"],[\"000524.SZ\",\"岭南控股\",\"7.88\",\"0.767\",180414661.81,3673609967.9200001,\"80.0492\",\"2145735400.000\"],[\"000525.SZ\",\"红太阳\",\"11.72\",\"0.515\",250286198.30000001,2568167660.6700001,\"-35.1542\",\"6731954700.000\"],[\"000526.SZ\",\"紫光学大\",\"26.46\",\"0.227\",94210210.700000003,1689952609.0799999,\"-6.812\",\"2545322500.000\"],[\"000528.SZ\",\"柳工\",\"6.42\",\"1.582\",660830164.01999998,10130931805.27,\"10.9173\",\"9390038200.000\"],[\"000529.SZ\",\"广弘控股\",\"6.67\",\"-1.185\",70305333.060000002,1315326599.8499999,\"19.8305\",\"3801128800.000\"],[\"000530.SZ\",\"大冷股份\",\"4.37\",\"3.066\",108373919.3,1075729240.5699999,\"83.63\",\"2612158700.000\"],[\"000531.SZ\",\"穗恒运A\",\"6.92\",\"0.435\",258563918.83000001,1413353804.4200001,\"<a href=\"tel:571.5038\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"58\">571.5038</a>\",\"4740773100.000\"],[\"000534.SZ\",\"万泽股份\",\"9.31\",\"0.649\",34904920.399999999,255619569.02000001,\"-51.6814\",\"4574707400.000\"],[\"000537.SZ\",\"广宇发展\",\"6.69\",\"1.827\",1551102016.24,8497486498.8400002,\"-5.385\",\"2715777500.000\"],[\"000538.SZ\",\"云南白药\",\"76.06\",\"0.648\",2247004753.1199999,13897383377.709999,\"8.5851\",\"46317941000.000\"],[\"000539.SZ\",\"粤电力A\",\"3.96\",\"0.508\",<a href=\"tel:581569383,12874181250\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"59\">581569383,12874181250</a>,\"29.5735\",\"10113471900.000\"],[\"000540.SZ\",\"中天金融\",\"3.56\",\"1.136\",1214200675.6800001,7304977525.8900003,\"-1.3527\",\"23142349000.000\"],[\"000541.SZ\",\"佛山照明\",\"5.28\",\"1.734\",167275725.75,1687184660.8599999,\"-27.0422\",\"5660537800.000\"],[\"000543.SZ\",\"皖能电力\",\"4.77\",\"1.274\",352776446.54000002,7382509694.4499998,\"<a href=\"tel:150.6661\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"60\">150.6661</a>\",\"8540188800.000\"],[\"000544.SZ\",\"中原环保\",\"6.45\",\"0.155\",171440327.75999999,747708196.40999997,\"-3.0023\",\"3364644300.000\"],[\"000545.SZ\",\"金浦钛业\",\"3.38\",\"2.736\",38865560.700000003,898951814.37,\"-37.1646\",\"3242782500.000\"],[\"000546.SZ\",\"金圆股份\",\"9.33\",\"-0.214\",190169730.46000001,3235925161.6500001,\"11.8276\",\"6231844000.000\"],[\"000547.SZ\",\"航天发展\",\"12.05\",\"-2.271\",222775102.84,1491924623.77,\"37.9196\",\"13277560800.000\"],[\"000548.SZ\",\"湖南投资\",\"4.19\",\"0.964\",20284657.510000002,129677189.73999999,\"-0.501\",\"2091518600.000\"],[\"000550.SZ\",\"江铃汽车\",\"14.80\",\"0.068\",<a href=\"tel:58861816,13721953502\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"61\">58861816,13721953502</a>,\"-81.5452\",\"7672720500.000\"],[\"000551.SZ\",\"创元科技\",\"6.72\",\"1.664\",56511927.829999998,1647596358.0999999,\"6.2555\",\"2688540300.000\"],[\"000552.SZ\",\"靖远煤电\",\"2.58\",\"1.177\",276342562.26999998,2031081235.22,\"-18.7703\",\"5892052500.000\"],[\"000553.SZ\",\"安道麦A\",\"9.50\",\"1.387\",<a href=\"tel:588638000,13616032000\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"62\">588638000,13616032000</a>,\"-75.3622\",\"4451858700.000\"],[\"000555.SZ\",\"神州信息\",\"11.60\",\"-0.258\",129143755.18000001,4130194003.4699998,\"-48.444\",\"10842148800.000\"],[\"000557.SZ\",\"西部创业\",\"3.74\",\"10.000\",66262241.640000001,366211217.94999999,\"30.8511\",\"2188817100.000\"],[\"000559.SZ\",\"万向钱潮\",\"5.42\",\"0.744\",327818044.35000002,5214638132.1999998,\"-27.1835\",\"14922070000.000\"],[\"000560.SZ\",\"我爱我家\",\"4.55\",\"1.563\",380897478.98000002,5679165517.2700005,\"15.8754\",\"8179764200.000\"],[\"000563.SZ\",\"陕国投A\",\"4.30\",\"2.138\",347874815.61000001,831901802.48000002,\"70.4502\",\"17045255000.000\"],[\"000565.SZ\",\"渝三峡A\",\"5.22\",\"0.772\",29356739.23,230214109.16999999,\"8.4803\",\"2263351400.000\"],[\"000566.SZ\",\"海南海药\",\"6.03\",\"0.500\",81074725.430000007,1407843079.9200001,\"-45.7604\",\"7257083700.000\"],[\"000567.SZ\",\"海德股份\",\"9.35\",\"5.650\",102593787.76000001,184927045.31999999,\"<a href=\"tel:103.0689\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"63\">103.0689</a>\",\"2036271300.000\"],[\"000568.SZ\",\"泸州老窖\",\"94.25\",\"-1.986\",2749781041.4200001,8013035019.7200003,\"39.7974\",\"137614920000.000\"],[\"000573.SZ\",\"粤宏远A\",\"3.04\",\"1.672\",48300623.219999999,221866824.52000001,\"<a href=\"tel:256.7037\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"64\">256.7037</a>\",\"1912457900.000\"],[\"000576.SZ\",\"广东甘化\",\"8.50\",\"0.000\",25027753.469999999,198704423.25,\"<a href=\"tel:167.5778\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"65\">167.5778</a>\",\"3637867600.000\"],[\"000581.SZ\",\"威孚高科\",\"17.28\",\"0.524\",1256661577.0899999,4403444346.0500002,\"-18.6755\",\"14454556000.000\"],[\"000582.SZ\",\"北部湾港\",\"9.16\",\"1.104\",473661575.22000003,2216476491.0700002,\"42.3567\",\"2410684800.000\"],[\"000584.SZ\",\"哈工智能\",\"6.36\",\"0.158\",35284059.109999999,765948804.41999996,\"-45.8739\",\"3805289300.000\"],[\"000589.SZ\",\"贵州轮胎\",\"4.36\",\"-0.229\",92930347.340000004,3220391467.3000002,\"<a href=\"tel:201.5349\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"66\">201.5349</a>\",\"3380692700.000\"],[\"000591.SZ\",\"太阳能\",\"3.25\",\"1.881\",377500937.50999999,2042537515.3,\"-14.4174\",\"6620571500.000\"],[\"000596.SZ\",\"古井贡酒\",\"121.25\",\"-2.603\",1248316314.01,5988112999.0900002,\"39.8795\",\"46511500000.000\"],[\"000597.SZ\",\"东北制药\",\"11.95\",\"0.000\",118955585.29000001,4110319650.4499998,\"18.9184\",\"6554319000.000\"],[\"000598.SZ\",\"兴蓉环境\",\"4.74\",\"0.851\",595067907.54999995,2113641699.4300001,\"12.0114\",\"14154676000.000\"],[\"000599.SZ\",\"青岛双星\",\"4.25\",\"0.236\",29646839.120000001,2159054145.5,\"-47.2266\",\"3262689100.000\"],[\"000600.SZ\",\"建投能源\",\"5.76\",\"1.947\",392267832.25,6965812175.7799997,\"<a href=\"tel:108.1867\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"67\">108.1867</a>\",\"6278654200.000\"],[\"000601.SZ\",\"韶能股份\",\"5.73\",\"0.175\",353787959.27999997,2194204977.3899999,\"73.4608\",\"6187437700.000\"],[\"000603.SZ\",\"盛达矿业\",\"17.46\",\"3.559\",212248567.21000001,1157346944.8900001,\"9.0253\",\"10240516500.000\"],[\"000606.SZ\",\"顺利办\",\"5.97\",\"1.877\",94831184.760000005,774710640.66999996,\"57.9173\",\"4221993600.000\"],[\"000607.SZ\",\"华媒控股\",\"4.74\",\"0.637\",42965196.57,831321795.70000005,\"27.4185\",\"4194144900.000\"],[\"000617.SZ\",\"中油资本\",\"12.88\",\"0.390\",4081647089.6900001,369544872.11000001,\"0.2735\",\"3703504900.000\"],[\"000620.SZ\",\"新华联\",\"4.65\",\"-1.274\",106091991.04000001,3270649557.9099998,\"-19.1282\",\"8819257200.000\"],[\"000623.SZ\",\"吉林敖东\",\"16.18\",\"1.506\",872113433.98000002,1642579794.0999999,\"43.3827\",\"18478003000.000\"],[\"000626.SZ\",\"远大控股\",\"7.44\",\"0.270\",46434495.450000003,32718020949.130001,\"<a href=\"tel:224.8618\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"68\">224.8618</a>\",\"3451761200.000\"],[\"000627.SZ\",\"天茂集团\",\"7.14\",\"3.628\",747578089.36000001,33153522693.130001,\"-11.7912\",\"30724342000.000\"],[\"000628.SZ\",\"高新发展\",\"9.75\",\"-0.409\",31821399.379999999,896673987.58000004,\"<a href=\"tel:132.9896\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"69\">132.9896</a>\",\"1832808300.000\"],[\"000629.SZ\",\"攀钢钒钛\",\"3.14\",\"2.280\",1199969773.1900001,7258692555.4499998,\"4.3071\",\"14968817000.000\"],[\"000630.SZ\",\"铜陵有色\",\"2.25\",\"0.897\",413875483.02999997,46859478870.559998,\"0.1819\",\"21511256000.000\"],[\"000631.SZ\",\"顺发恒业\",\"2.86\",\"0.351\",440706643.13999999,1035882796.87,\"-41.5098\",\"6957004800.000\"],[\"000635.SZ\",\"英力特\",\"7.92\",\"1.279\",34662636.75,955471573.38999999,\"-59.6302\",\"2400453800.000\"],[\"000636.SZ\",\"风华高科\",\"13.69\",\"4.345\",297948797.88999999,1614081543.78,\"-27.9801\",\"12255330600.000\"],[\"000637.SZ\",\"茂化实华\",\"4.64\",\"0.651\",83526010.680000007,2004518268.5999999,\"<a href=\"tel:259.2727\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"70\">259.2727</a>\",\"1700536600.000\"],[\"000639.SZ\",\"西王食品\",\"5.34\",\"0.565\",224300930.38,2774186788.0599999,\"9.6589\",\"5747702200.000\"],[\"000650.SZ\",\"仁和药业\",\"7.35\",\"-0.407\",323755137.49000001,2451601846.0999999,\"32.4834\",\"8675889600.000\"],[\"000651.SZ\",\"格力电器\",\"59.85\",\"3.547\",13750194088.889999,97296964334.889999,\"7.3714\",\"357299660000.000\"],[\"000652.SZ\",\"泰达股份\",\"3.67\",\"0.548\",61468568.310000002,6632694260.2299995,\"44.3965\",\"5410041300.000\"],[\"000655.SZ\",\"金岭矿业\",\"5.52\",\"0.546\",84347088.810000002,607660671.95000005,\"<a href=\"tel:106.4194\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"71\">106.4194</a>\",\"3286278100.000\"],[\"000656.SZ\",\"金科股份\",\"6.76\",\"0.896\",2589997663.5900002,26105120363.700001,\"<a href=\"tel:288.5026\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"72\">288.5026</a>\",\"35471329000.000\"],[\"000657.SZ\",\"中钨高新\",\"6.92\",\"3.284\",73655877.659999996,4046449211.0500002,\"-3.5965\",\"5352762000.000\"],[\"000661.SZ\",\"长春高新\",\"349.88\",\"-0.248\",726629081.48000002,3391554091.9699998,\"32.5993\",\"59487331000.000\"],[\"000662.SZ\",\"天夏智慧\",\"4.54\",\"-2.366\",65071334.380000003,255860408.91999999,\"-47.956\",\"4962132500.000\"],[\"000665.SZ\",\"湖北广电\",\"5.69\",\"0.708\",131129854.83,1257388239.8399999,\"-26.8001\",\"5482063500.000\"],[\"000666.SZ\",\"经纬纺机\",\"12.58\",\"1.125\",354233221.19,2824088232.4400001,\"17.7493\",\"3692466100.000\"],[\"000668.SZ\",\"荣丰控股\",\"15.85\",\"3.934\",65320285.759999998,310666428.07999998,\"1263.8675\",\"2325011000.000\"],[\"000671.SZ\",\"阳光城\",\"6.01\",\"4.340\",1449129219.77,22511470100.619999,\"40.5207\",\"23871048000.000\"],[\"000672.SZ\",\"上峰水泥\",\"13.20\",\"1.931\",950070445.46000004,2888343717.4099998,\"86.425\",\"10739645700.000\"],[\"000676.SZ\",\"智度股份\",\"6.14\",\"1.153\",326504348.58999997,4859837699.0699997,\"-25.3162\",\"4014561300.000\"],[\"000680.SZ\",\"山推股份\",\"3.76\",\"1.897\",44122350.119999997,3481615917.54,\"-41.1213\",\"3974056500.000\"],[\"000681.SZ\",\"视觉中国\",\"23.11\",\"-3.628\",132562346.38,402142506.63,\"-3.0964\",\"7174800500.000\"],[\"000682.SZ\",\"东方电子\",\"4.70\",\"2.174\",100770105.34,1394113548.3499999,\"<a href=\"tel:121.3833\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"73\">121.3833</a>\",\"4596706900.000\"],[\"000683.SZ\",\"远兴能源\",\"2.42\",\"0.415\",473151377.43000001,3645939776.27,\"-27.5364\",\"8561431500.000\"],[\"000685.SZ\",\"中山公用\",\"8.01\",\"1.136\",498694799.10000002,860148211.03999996,\"27.2461\",\"10038371600.000\"],[\"000686.SZ\",\"东北证券\",\"8.45\",\"1.807\",589740750.22000003,3879881169.27,\"<a href=\"tel:137.2476\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"74\">137.2476</a>\",\"19776827000.000\"],[\"000688.SZ\",\"国城矿业\",\"10.46\",\"-1.321\",154848800.28,558321023.76999998,\"-39.5483\",\"11896105600.000\"],[\"000690.SZ\",\"宝新能源\",\"5.86\",\"1.560\",317003291.73000002,2150656099.9000001,\"-35.0049\",\"12212958900.000\"],[\"000698.SZ\",\"沈阳化工\",\"4.11\",\"3.266\",60892832.520000003,4882338301.2399998,\"-9.9557\",\"3229163900.000\"],[\"000700.SZ\",\"模塑科技\",\"3.48\",\"0.578\",59583122.280000001,2523583288.3000002,\"<a href=\"tel:349.4735\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"75\">349.4735</a>\",\"2495894300.000\"],[\"000703.SZ\",\"恒逸石化\",\"12.08\",\"5.965\",1276796952.98,41729497124.889999,\"2.9439\",\"27527123000.000\"],[\"000705.SZ\",\"浙江震元\",\"6.62\",\"-0.151\",46234554.560000002,1564910070.21,\"8.0509\",\"1866731700.000\"],[\"000708.SZ\",\"大冶特钢\",\"15.09\",\"1.004\",294019254.38,6386368645.5299997,\"15.0158\",\"6781574000.000\"],[\"000709.SZ\",\"河钢股份\",\"2.61\",\"0.772\",1168460906.8399999,62394053081.300003,\"-35.8697\",\"27710090000.000\"],[\"000710.SZ\",\"贝瑞基因\",\"34.99\",\"5.582\",250826232.00999999,753237670.25999999,\"71.9532\",\"8073688800.000\"],[\"000712.SZ\",\"锦龙股份\",\"12.40\",\"2.395\",78173240.909999996,823986725.24000001,\"<a href=\"tel:262.0031\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"76\">262.0031</a>\",\"9870360300.000\"],[\"000713.SZ\",\"丰乐种业\",\"10.35\",\"-0.672\",26915620.32,1186712547.3499999,\"1219.4082\",\"4021376100.000\"],[\"000715.SZ\",\"中兴商业\",\"10.80\",\"-0.185\",88356656.290000007,1374470552.1600001,\"<a href=\"tel:121.6115\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"77\">121.6115</a>\",\"3008496300.000\"],[\"000717.SZ\",\"韶钢松山\",\"4.00\",\"2.041\",1007186502.41,13788449494.76,\"-42.6677\",\"9678097600.000\"],[\"000718.SZ\",\"苏宁环球\",\"3.94\",\"2.338\",620993634.16999996,1717480436.05,\"47.4465\",\"9020052500.000\"],[\"000719.SZ\",\"中原传媒\",\"7.30\",\"0.137\",365097414.94,4152786063.0300002,\"6.1479\",\"4870177100.000\"],[\"000720.SZ\",\"新能泰山\",\"4.70\",\"-0.212\",368290278.12,1925841358.6600001,\"-34.5248\",\"4058262000.000\"],[\"000722.SZ\",\"湖南发展\",\"6.93\",\"0.435\",86558373.650000006,163992303.66,\"67.1355\",\"3216616900.000\"],[\"000723.SZ\",\"美锦能源\",\"10.09\",\"6.099\",623598348.85000002,7731373121.25,\"2.102\",\"10909726200.000\"],[\"000725.SZ\",\"京东方A\",\"3.74\",\"0.000\",<a href=\"tel:1668448449,55039208687\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"78\">1668448449,55039208687</a>,\"-43.9216\",\"126635463000.000\"],[\"000726.SZ\",\"鲁泰A\",\"9.23\",\"0.000\",411446216.58999997,3185448344.0100002,\"9.034\",\"5178742100.000\"],[\"000728.SZ\",\"国元证券\",\"8.77\",\"1.740\",432642231.88999999,1585037421.6300001,\"86.7368\",\"25837557000.000\"],[\"000729.SZ\",\"燕京啤酒\",\"6.06\",\"-0.493\",512372275.5,6461860626.8800001,\"1.1268\",\"15207228000.000\"],[\"000731.SZ\",\"四川美丰\",\"5.37\",\"0.562\",63489365.259999998,1506715132,\"-48.2576\",\"3176271000.000\"],[\"000732.SZ\",\"泰禾集团\",\"6.46\",\"2.703\",1560867245.8599999,14506174537.969999,\"58.7396\",\"16060267000.000\"],[\"000733.SZ\",\"振华科技\",\"18.11\",\"-0.385\",219097699.84999999,2173039032.8699999,\"33.7544\",\"8499787600.000\"],[\"000736.SZ\",\"中交地产\",\"6.59\",\"4.272\",92926286.290000007,1747648532.5599999,\"-82.8371\",\"3525313900.000\"],[\"000738.SZ\",\"航发控制\",\"15.37\",\"0.000\",179079365.72999999,1368535902.52,\"7.1398\",\"17608401000.000\"],[\"000739.SZ\",\"普洛药业\",\"11.50\",\"1.950\",280837123,3549373828.02,\"50.6102\",\"13188476700.000\"],[\"000750.SZ\",\"国海证券\",\"5.13\",\"1.584\",388455983.55000001,1862532301.4100001,\"280.652\",\"21625713000.000\"],[\"000751.SZ\",\"锌业股份\",\"3.24\",\"1.250\",67685116.609999999,3742208361.9099998,\"27.8804\",\"4567967100.000\"]]}"
        
        
        var modified = "{[\"000553.SZ\",\"安道麦A\",\"9.50\",\"1.387\",<a href=\"tel:588638000,13616032000\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"69\">588638000,13616032000</a>,\"-75.3622\",<a href=\"tel:4451858669\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"70\">4451858669</a>],[\"000001.SZ\",\"平安银行\",\"14.44\",\"0.979\",<a href=\"tel:15403000000,67829000000\" dir=\"ltr\" x-apple-data-detectors=\"true\" x-apple-data-detectors-type=\"telephone\" x-apple-data-detectors-result=\"41\">15403000000,67829000000</a>,\"15.1885\",\"247938350000.000\"]]}"
        
        
        var regex = "\"<a\\s+href=([^\\[]+)>([^\\[]+)</a>\""
        var RE = try! NSRegularExpression(pattern: regex, options: .caseInsensitive)
         modified = RE.stringByReplacingMatches(in: modified, options: .reportCompletion, range: NSRange(location: 0, length: modified.count), withTemplate: "$2")
        
//        regex = "<a\\s+href=([^\\[]+)>([^\\[]+)</a>\\]"
//        RE = try! NSRegularExpression(pattern: regex, options: .caseInsensitive)
//        modified = RE.stringByReplacingMatches(in: modified, options: .reportProgress, range: NSRange(location: 0, length: modified.count), withTemplate: "$2\\]")
        
        regex = "<a\\s+href=([^\\[<]+)>([^\\[<]+)</a>"
         RE = try! NSRegularExpression(pattern: regex, options: .caseInsensitive)
        let matches = RE.matches(in: modified, options: .reportProgress, range: NSRange(location: 0, length: modified.count))
        print(matches.count)
         modified = RE.stringByReplacingMatches(in: modified, options: .reportCompletion, range: NSRange(location: 0, length: modified.count), withTemplate: "$2")
        
        
        
       print(modified)
    }
    
    private func gotoViewController(storyboard:String,storyboardId:String) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: storyboard,bundle: nil)
        var destViewController : UIViewController
        destViewController = mainStoryboard.instantiateViewController(withIdentifier: storyboardId)
        self.navigationController?.navigationController?.pushViewController(destViewController, animated: true)
    }
    
    private func setupLayoutData() {
        var item:ItemData?
        var title:String
        var layout:LayoutData?
        var items:[ItemData] = []
        
        
        // Group 0
        title = SectionType.QuickActions.description()
        items.removeAll()
        // Item 1
        item = ItemData(title: "复盘总结", data:nil, onItemClicked: { itemData in
            self.gotoViewController(storyboard: "Review", storyboardId: "ReviewDetailViewController")
        })
        items.append(item!)
        // Item 2
        item = ItemData(title: "涨停排行榜", data:nil, onItemClicked: { itemData in
            self.gotoViewController(storyboard: "Block", storyboardId: "ZhangTingListViewController")
        })
        items.append(item!)
    
        layout = LayoutData(title: title,data: items)
        self.layoutData.append(layout!)
        
        // Group 1
        title = SectionType.BlockPeriod.description()
        items.removeAll()
        // Item 1
        item = ItemData(title: "板块周期表", data:nil, onItemClicked: { itemData in
            print(itemData.title)
            self.gotoViewController(storyboard: "Block", storyboardId: "BlockCycleViewController")
        })
        items.append(item!)
        // Item 2
        item = ItemData(title: "热门板块",data: nil,onItemClicked: {itemData in
            print(itemData.title)
            self.gotoViewController(storyboard: "Block", storyboardId: "HotBlockViewController")
        })
        items.append(item!)
        layout = LayoutData(title: title,data: items)
        self.layoutData.append(layout!)
        
        // Group 2
        title = SectionType.Xuangu.description()
        items.removeAll()
        // Item 1
        item = ItemData(title: "自定义选股", data: nil,onItemClicked: { itemData in
            print(itemData.title)
            self.gotoViewController(storyboard: "Data", storyboardId: "XuanguListViewController")
        })
        items.append(item!)
        layout = LayoutData(title: title,data: items)
        self.layoutData.append(layout!)
        
        // Group 3
        title = SectionType.WebSite.description()
        items.removeAll()
        // Item 1
        item = ItemData(title: "问财选股", data: "https://www.iwencai.com", onItemClicked: {[weak self] itemData in
            self?.openWebSite(itemData: itemData)
        })
        items.append(item!)
        // Item 2
        item = ItemData(title: "北向资金", data: "http://data.eastmoney.com/hsgt/index.html", onItemClicked: {[weak self] itemData in
            self?.openWebSite(itemData: itemData)
        })
        items.append(item!)
        // Item 3
        item = ItemData(title: "涨跌温度计", data: "http://stock.jrj.com.cn/tzzs/zdtwdj.shtml", onItemClicked: { [weak self] itemData in
            self?.openWebSite(itemData: itemData)
        })
        items.append(item!)
        // Item 4
        item = ItemData(title: "限售解禁", data: "http://data.10jqka.com.cn/market/xsjj/", onItemClicked: { [weak self] itemData in
            self?.openWebSite(itemData: itemData)
        })
        items.append(item!)
        // Item 5
        item = ItemData(title: "新股上市", data: "http://data.10jqka.com.cn/ipo/xgsgyzq/", onItemClicked: { [weak self] itemData in
            self?.openWebSite(itemData: itemData)
        })
        items.append(item!)
        layout = LayoutData(title: title,data: items)
        self.layoutData.append(layout!)
    }
    
    private func openWebSite(itemData:ItemData) {
        WebViewController.open(website: (itemData.data!), withtitle: itemData.title, from: (self.navigationController?.navigationController)!)
    }
    
    func reloadData() {
        DispatchQueue.main.async(execute: {
            print(Thread.isMainThread)
            self.collectionView.reloadData()
        })
 
    }
        
    func loadData() -> Void {
        
        let myQueue = DispatchQueue(label: "initData")
        let group = DispatchGroup()
        
        DispatchQueue.main.async(execute: {
            print(Thread.isMainThread)
            ZKProgressHUD.show()
        })
     
        // 1
        myQueue.async(group: group, qos: .default, flags: [], execute: {
            print("task 1")
            StockServiceProvider.getBasicData()
            StockServiceProvider.buildBlock2StocksCodeMap()
        })
        // 2
        myQueue.async(group: group, qos: .default, flags: [], execute: {
            print("task 2")
            // 股票基本信息列表
//            StockServiceProvider.getStockList { [weak self] (stocks) in
//                print("getStockList",stocks.count)
//            }
        })
        
        // all
        group.notify(queue: myQueue) {
            print("notify")
            
            DispatchQueue.main.async(execute: {
                print(Thread.isMainThread)
                ZKProgressHUD.dismiss()
                //ZKProgressHUD.showSuccess()
            })
        }
    }
}

// MARK: UICollectionViewDataSource
extension HomeViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.layoutData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.layoutData[section].data.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let group = self.layoutData[section]
        if section == SectionType.BlockPeriod.rawValue
            || section == SectionType.HotBlocks.rawValue
            || section == SectionType.HotStocks.rawValue
            || section == SectionType.WebSite.rawValue
            || section == SectionType.QuickActions.rawValue
        {
            let item = group.data[row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagReuseIdentifier, for: indexPath)
                as! TagCollectionViewCell
            cell.contentButton.text = item.title
            
            cell.onClicked = { () -> Void in
                print("Button clicked:\(cell.contentButton.text!)")
                item.onItemClicked(item)
            }
            // Configure the cell
            
            return cell
        }

        
        // never go here
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagReuseIdentifier, for: indexPath)
        return cell
    }
    
    // Header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let group = self.layoutData[indexPath.section]
        //1
        switch kind {
        //2
        case UICollectionView.elementKindSectionHeader:
            //3
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: headerReuseIdentifier,
                                                                             for: indexPath) as! HeaderCollectionView
            headerView.contentLabel.text = group.title
            return headerView
        default:
            //4
            assert(false, "Unexpected element kind")
        }
        return UICollectionViewCell(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
}


// MARK: UICollectionViewDelegate
extension HomeViewController {
    
    //      Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    //      Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        let item = self.layoutData[section].data[row]
        print(item)
    }
    
    //      Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }
    
    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
    //let screenWidth = UIScreen.main.bounds.size.width;
        let height = Theme.CellView.height
        var width = Int(UIScreen.main.bounds.size.width / CGFloat(columns))
        if width < Int(Theme.TagButton.width) {
            width = Int(Theme.TagButton.width)
        }
//        if indexPath.section == SectionType.HotStocks.rawValue {
//            return CGSize(width: screenWidth, height: 60)
//        }
        return CGSize(width: width, height: Int(height))
    }
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
//        if section == SectionType.HotStocks.rawValue {
//            return stockSectionInsets
//        }
        return sectionInsets
    }
    // 4
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    // 5
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: CGFloat(Theme.CollectionHeaderView.height))
    }
}


