import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';
import 'package:widget_test/.env.dart';
import 'package:widget_test/directions_model.dart';

class DirectionsRepo {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;
  DirectionsRepo({Dio? dio}) : _dio = dio ?? Dio();

  Future<Directions> getDirections({
    @required LatLng? origin,
    @required LatLng? destination,
  }) async {
    print('-------------------');
    print('Getting Directions in repo-class...');
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin!.latitude}, ${origin.longitude}',
        'destination': '${destination!.latitude}, ${destination.longitude}',
        'key': googleAPIKey,
      },
    );
    print('-------------------');
    print('Got Directions in repo-class...');
    // print('direction_repo: reponse is: ');
    //{"geocoded_waypoints":[{"geocoder_status":"OK","place_id":"ChIJdcQn84h9j4ARv_CCkhqf8eU","types":["premise"]},{"geocoder_status":"OK","place_id":"ChIJ8c_h0DR5j4ARI2dhzv8coaw","types":["premise"]}],"routes":[{"bounds":{"northeast":{"lat":37.7508701,"lng":-122.4081166},"southwest":{"lat":37.6868066,"lng":-122.4794878}},"copyrights":"Map data ©2021","legs":[{"distance":{"text":"10.2 mi","value":16487},"duration":{"text":"23 mins","value":1393},"end_address":"27 Huckleberry Ct, Brisbane, CA 94005, USA","end_location":{"lat":37.6946842,"lng":-122.4204073},"start_address":"1974 22nd Ave, San Francisco, CA 94116, USA","start_location":{"lat":37.7508701,"lng":-122.4794878},"steps":[{"distance":{"text":"0.3 mi","value":471},"duration":{"text":"1 min","value":62},"end_location":{"lat":37.7466414,"lng":-122.4791948},"html_instructions":"Head <b>south</b> on <b>22nd Ave</b> toward <b>Pacheco St</b>","polyline":{"points":"}eleFxwpjVLAb@Ab@AJAjBGhGQnCIb@AnCIp@C"},"start_location":{"lat":37.7508701,"lng":-122.4794878},"tra

    // print('reponse.data is: ');
    // printWrapped(response.data.toString());

    // Check if response is successful
    if (response.statusCode == 200) {
      print('-------------------');
      print('status code is 200');
      return Directions.fromMap(response.data);
      // ^ This Factory Constructor is part of the Directions model,
      // and convert the reponse data of type Map<String, Dynamic> into Directions
    } else {
      print('-------------------');
      print('Status Code is not 200. Something went wrong.');
      return Directions.fromMap(response.data);
    }
  }

  // Print very large String
  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}

// {geocoded_waypoints:
// [{geocoder_status: OK, place_id: ChIJ_0s4bD55j4ARzKYYRfJI99Q, types: [route]},
// {geocoder_status: OK, place_id: ChIJy97TFY99j4AR2dSubKTGfto, types: [premise]}],

// routes: [
//  {
//    bounds:
//      {northeast:
//          {lat: 37.7476659,
//           lng: -122.4150964},
//       southwest:
//          {lat: 37.6670365,
//           lng: -122.4792629}},
//    copyrights: Map data ©2021,
//    legs: [
//       {
//          distance: {text: 9.5 mi, value: 15247},
//          duration: {text: 23 mins, value: 1351},
//          end_address: 2142 22nd Ave, San Francisco, CA 94116, USA,
//          end_location: {lat: 37.7476659, lng: -122.4792629},
//          start_address: Ridge Trail, South San Francisco, CA 94080, USA,
//          start_location: {lat: 37.6727124, lng: -122.4177928},
// steps: [
//   {distance: {
//        text: 0.1 mi,
//        value: 204},
//   duration: {
//        text: 1 min,
//        value: 37},
//   end_location: {lat: 37.6716096, lng: -122.4169804},
//   html_instructions: Head <b>east</b> on <b>Parkridge Cir</b> toward <b>Skypark Cir</b>,
//   polyline: {points: m}|dFdvdjVAE?E?E?G?G@Q?M@[@OB[BM@K?ABIBIBEBE@CBCBC@?@ABCBABAFADAD?D?@@F@|Ah@`@N},
//   start_location: {lat: 37.6727124, lng: -122.4177928}, travel_mode: DRIVING}, {distance: {text: 0.2 mi, value: 254}, duration: {text: 1 min, value: 48}, end_location: {lat: 37.6700445, lng: -122.4150976}, html_instructions: Turn <b>left</b> onto <b>Parkgrove Dr</b>, maneuver: turn-left, polyline: {points: qv|dFbqdjVPy@Ha@HWJ]DMBGDIBGJQJQDG@CBEDE@ABC@CBC@AHI@ADEDCDEDEJGBCBAHGJGDCBANIHGPIJGDCDCD?DAR@}, start_location: {lat: 37.6716096, lng: -122.4169804}, travel_mode: DRIVING}, {distance: {text: 253 ft, value: 77}, duration: {text: 1 min, value: 15}, end_location: {lat: 37.6697828, lng: -122.4158733}, html_instructions: Turn <b>r
// ight</b> onto <b>Greenpark Terrace</b>, maneuver: turn-right, polyline: {points: wl|dFjedjV?P?N@D?F?D@D@JBJ@B@FBFDJFHBDNT}, start_location: {lat: 37.6700445, lng: -122.4150976}, travel_mode: DRIVING}, {distance: {text: 0.1 mi, value: 175}, duration: {text: 1 min, value: 23}, end_location: {lat: 37.6701477, lng: -122.4177655}, html_instructions: Turn <b>right</b> onto <b>S San Francisco Dr</b>, maneuver: turn-right, polyline: {points: ck|dFdjdjVCBABIREHCHCHAFADAFAF?HAD?H?HAL?L@D?Z?Z?P?N?@AJAH?DCJ?BADCJEVMj@}, start_location: {lat: 37.6697828, lng: -122.4158733}, travel_mode: DRIVING}, {distance: {text: 322 ft, value: 98}, duration: {text: 1 min, value: 16}, end_location: {lat: 37.6694918, lng: -122.4182612}, html_instructions: Turn <b>left</b> to stay on <b>S San Francisco Dr</b>, maneuver:
// turn-left, polyline: {points: mm|dF`vdjVGXF@F@HBFD@@JHHFPJB@^NZF}, start_location: {lat: 37.6701477, lng: -122.4177655}, travel_mode: DRIVING}, {distance: {text: 2.2 mi, value: 3611}, duration: {text: 4 mins, value: 248}, end_location: {lat: 37.6807334, lng: -122.4528766}, html_instructions: Turn <b>right</b> at the 1st cross street onto <b>Hillside Blvd</b>, maneuver: turn-right, polyline: {points: ii|dFbydjVWlACNETEVCLAJAHAJCV?N?H?D?D?H?H?H@D?D?D@F?D@HBNBPBNDVFV@HJj@H^b@xBHd@Np@T|@Lj@R`A?BJd@H\Hb@Hb@H\h@vBL\HVFNBDBDDHHJJNFJN@f@j@BJ@B@DLPDDJLX\@?X\JPHPDL?@BF@FFX@H@JBV?F?B?R?LA^Gh@Ib@EZKj@UpAKp@Ib@SrAG^Kh@I\Qj@i@tAiAdC?@Ub@Sd@O\CFSb@]t@S\[b@ORWZa@b@WVCBUZKNIN?@ILYp@Sb@Sd@_AnBc@~@m@rAgA~Bk@rAMTi@lAGPc@dAM`@Yt@EJEJCJAJq@|Ai@jAqBtEGJSb@i@lAmAlCe@fAg@hAUd@_@z@Sb@eBzDUh@Sd@Sb@Sd@oArCGJcAzBWj@c
// @`Am@rAADsBnEQ^Q^Uf@Sd@A@Qb@GLUf@GL[r@CFk@nAQ^iAhCk@pAEJg@dASd@Sb@_@~@Qb@_ArBs@bB}, start_location: {lat: 37.6694918, lng: -122.4182612}, travel_mode: DRIVING}, {distance: {text: 1.0 mi, value: 1557}, duration: {text: 3 mins, value: 206}, end_location: {lat: 37.6708051, lng: -122.4644001}, html_instructions: Turn <b>left</b> onto <b>Serramonte Blvd</b>, maneuver: turn-left, polyline: {points: qo~dFnqkjV\VDDDBDDFHDFHJ`@p@JPBFvA`Cr@lAPZZh@|AjCzAhCf@v@LTBDHJJLPNHDFB@@FDNHPF@@FBFFNRFJ`@p@BF@@f@z@DFVb@T\l@dAdAfBXd@NVl@bABDh@~@n@bAR\HJPZT`@Vb@BDp@hADHRZLR|@lAPb@\h@PVHNJPf@v@\d@?@V^V\@@^RJHt@JHA`@EPAVCZEJAPE@?B?TCR@H@RJLBFDFBB@@BFDBDFFFJNZ}, start_location: {lat: 37.6807334, lng: -122.4528766}, travel_mode: DRIVING}, {distance: {text: 2.3 mi, value: 3641}, duration: {text: 3 mins, value: 154}, en

//  d_location: {lat: 37.701016, lng: -122.4713798}, html_instructions: Slight <b>right</b> at Chipotle Mexican Grill to merge onto <b>I-280 N</b> toward <b>San Francisco</b>, maneuver: ramp-right, polyline: {points: qq|dFnymjVPXG^?FAH?H?FA`@?B?V?FAPALALADALCHCHAFCFINEFA@INMJ[ZwAdAi@\WPKH{@j@MHCBABCBC@ABCBADOZIHkAx@y@l@yAjAOJeAx@_Ar@QJMP_An@MHIHUPkA|@y@l@A?]V_@ZWPCB]VIF_@Xa@Va@T_@POHA?_@NKD]LQFi@N[HE@YFa@FSBYDA?_@DA?]BI?S@U@Y?o@?[AYAE?O?c@A_FK{CGK@wBGkCE_@CgAGWC{@Cu@AQAO?c@?g@Aq@AyAEQAe@COAOA]CEAy@KOCOCOEc@Ia@KOCSEa@Ke@Mc@IOEMEc@IAAq@OUE]GWGa@Gc@Em@Ee@CE?m@AaC?u@@cLBuB@K?m@@k@?_@@O?q@DA?c@Bs@HaAPUFUF_@Hg@LwCx@s@PODk@Hs@Lq@F[@Q@U@a@?_@@W?_@?_@?c@@kAB_@@k@@kA?w@@aA@}, start_location: {lat: 37.6708051, lng: -122.4644001}, travel_mode: DRIVING}, {distance: {text: 0.5 mi, value: 839}, duration: {te
// xt: 1 min, value: 30}, end_location: {lat: 37.7085366, lng: -122.4710482}, html_instructions: Take exit <b>49B</b> on the <b>left</b> for <b>CA-1 N</b> toward <b>19th Avenue</b>/<wbr/><b>Golden Gate Brg</b>, maneuver: ramp-left, polyline: {points: knbeFbeojVEDIBK@I@m@@m@@O@iBBk@@g@@A?U?_@@E?_@@e@?c@?W?O?G?U?C?e@Ac@AA?]Ca@AUAUC_@Ca@CK?}@GE?YCGAg@CcAGMA_BKw@GgAGc@Ci@EQAg@CG?SAU?]?}, start_location: {lat: 37.701016, lng: -122.4713798}, travel_mode: DRIVING}, {distance: {text: 0.6 mi, value: 951}, duration: {text: 1 min, value: 74}, end_location: {lat: 37.71695589999999, lng: -122.4724685}, html_instructions: Continue onto <b>CA-1 N</b>/<wbr/><b>Junipero Serra Blvd</b>, polyline: {points: k}ceF`cojViB?G?G@wA@g@?E?aA@eB?k@?q@?y@@s@@o@?g@BC?_@@O@M@e@DE?m@DSBgANoBVy@NkAXcBb@o@Po@P_@Lw@RIB_@HMD]Fa
// APe@L}, start_location: {lat: 37.7085366, lng: -122.4710482}, travel_mode: DRIVING}, {distance: {text: 1.7 mi, value: 2773}, duration: {text: 5 mins, value: 320}, end_location: {lat: 37.7411974, lng: -122.4755076}, html_instructions: Slight <b>left</b> onto <b>19th Ave</b>, maneuver: turn-slight-left, polyline: {points: _reeF|kojVS@A@A?A?A?A@A?A?A?E@G@EBEBEBEBEDCDo@`@o@t@GFg@d@wBrBuApAuApAURKHCBCBIDKDOHMDA?IDG@I@IBI@E?G?G@E?wBGO?q@EmCGs@AwCEoCG_FMiCEw@Cc@?g@Ak@A{@CM?WAK?WAi@CmACKAI?gACwAEg@AK?O?]?I?a@Bg@@W@Q@E@w@@[@YBc@@kBFk@@cDJ}@D]@m@@k@B_ABoFN_@BoCF[@E?Q@Y?I@{ABq@BoDJg@?yCJeABc@Bw@BO@[@cBDuFP}, start_location: {lat: 37.71695589999999, lng: -122.4724685}, travel_mode: DRIVING}, {distance: {text: 66 ft, value: 20}, duration: {text: 1 min, value: 5}, end_location: {lat: 37.7412069, lng: -1
// 22.4752783}, html_instructions: Turn <b>right</b> onto <b>Ulloa St</b>, maneuver: turn-right, polyline: {points: oijeF|~ojVAm@}, start_location: {lat: 37.7411974, lng: -122.4755076}, travel_mode: DRIVING}, {distance: {text: 0.2 mi, value: 311}, duration: {text: 1 min, value: 66}, end_location: {lat: 37.7410558, lng: -122.4788038}, html_instructions: Make a <b>U-turn</b>, maneuver: uturn-left, polyline: {points: qijeFn}ojV@l@@T?N?N@l@@^?R@`@@l@?J@PDhC@\?L@l@DvC?N}, start_location: {lat: 37.7412069, lng: -122.4752783}, travel_mode: DRIVING}, {distance: {text: 0.5 mi, value: 736}, duration: {text: 2 mins, value: 109}, end_location: {lat: 37.7476659, lng: -122.4792629}, html_instructions: Turn <b>right</b> onto <b>22nd Ave</b><div style="font-size:0.9em">Destination will be on the right</div>,

//  maneuver: turn-right, polyline: {points: shjeFnspjVO@_@@c@BsELC?e@@M@EAM@I?W@[@a@@w@Dc@@}@BG@EAu@Bc@@Q@c@@a@BwELc@Bc@@M?q@BoCHK?}, start_location: {lat: 37.7410558, lng: -122.4788038}, travel_mode: DRIVING}], traffic_speed_entry: [], via_waypoint: []}], overview_polyline: {points: m}|dFdvdjVAYBcAJeAJ[LQJGVEF@dBj@`@NPy@Ry@Z}@n@eAb@c@z@m@n@]\OX??`@BXHb@Tb@NTCBKVM\Iv@?dCM~@SbAGXF@PDHFj@^^NZFWlAId@Id@Ix@@hA@XLz@ZdBfApF`BzHr@tCVt@Td@\f@N@f@j@DN`@j@`AlARh@Lv@Bv@?LIhAq@|Di@hDShA[hAi@tAiAdCUd@{@nBq@rAk@v@qAvAo@~@}EnKkDvHsAnDQn@uEjKcHvOsIpRcGvM_CjFyFjMeCzFs@bB\VJH\b@hClEtI|NTXZT`@TRHNJ|@xAjFzIjEjHbBtCXd@jA`BPb@\h@Zf@pApBn@|@`@TJHt@Jj@GpAMVETCR@\L`@NTVVf@PXG^AP?PAdAGr@Kh@U`@WZ[ZwAdAaAn@gAt@WTKNYd@eCfBoFdE_@\mAx@eDfCwAdAkA|@sBhAkAb@wA`@uAT}@JqAF_CCyGMkLS{DS{BCeEKeAGmBUeB_@qEcAgB_@y@OqAKk@CoDA{QFiCBs
// @DwALmCj@_EfAcAV_BVmAHiBD_JHyBBOHUB{ABmEH}@@sD@iBGmBK_G]uJm@oAAqEBmJBoCDcBJoCXiDf@oD|@wDdAuAZgB^UBG@K@YL_Ap@w@|@_DxCmE`E]Ri@Te@H[@gCG_EM{P]mGKmCG{CIyFMqBDgBFqNd@{Qf@{KVaUr@Am@@l@BbBNhIFbFgHTiCF{DLgBDwL^{CH}, summary: Hillside Blvd, warnings: [], waypoint_order: []}], status: OK}
