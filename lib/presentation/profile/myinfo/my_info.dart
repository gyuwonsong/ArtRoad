import 'package:android_intent_plus/android_intent.dart';
import 'package:artroad/core/app_export.dart';
import 'package:artroad/presentation/login/login_screen.dart';
import 'package:artroad/presentation/services/firebase_auth_services.dart';
import 'package:artroad/presentation/services/firebase_firestore_services.dart';
import 'package:artroad/src/provider/user_provider.dart';
import 'package:artroad/widgets/custom_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class MyInfo extends StatefulWidget {
  const MyInfo({super.key});

  @override
  State<MyInfo> createState() => _MyInfo();
}

class _MyInfo extends State<MyInfo> {
  bool condition1 = false; // 약관 동의
  bool condition2 = false; // 이메일 일치

  final TextEditingController _controller = TextEditingController();
  //사용자 이메일 값 불러오기
  String _storedValue = '';

  @override
  void dispose() {
    _controller.dispose(); // 컨트롤러를 폐기해야 합니다.
    super.dispose();
  }

  // void _saveValue() {
  //   setState(() {
  //     _storedValue = _controller.text;
  //   });
  // }


  // 탈퇴하기 Dialog
  void _showResignDialog(String userEmail, String userId) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter bottomState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 20, left: 35, right: 35, bottom: 20),
                child: Container(
                  // 키보드 창 크기만큼 컨텐츠 올리기
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // --- 구현부 ---
                              const Text(
                                '탈퇴하기',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 15),

                              Column(
                                children: [
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '회원 탈퇴 전, 유의사항을 확인해 주시기 바랍니다.',
                                        style: TextStyle(
                                          fontSize: 13,
                                        ),
                                      ),

                                      Text(
                                        '유의사항 확인',
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontSize: 11,
                                          color: Color(0xFF939191),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            bottomState((){
                                              setState(() {
                                                condition1 = !condition1;
                                              });
                                            });
                                          },
                                          child: Icon(
                                            condition1 ? Icons.check_box_rounded : Icons.square_outlined,
                                            size: 16,
                                            color: const Color(0xFF176FF2),
                                          ),
                                        ),
                                        const SizedBox(width: 3),
                                        const Text(
                                          'ArtRoad 회원 탈퇴 시 처리사항 안내를 확인하였음에 동의합니다.',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF176FF2),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 15),

                              const Divider(),

                              const SizedBox(height: 15),

                              TextFormField(
                                controller: _controller,
                                cursorColor: Colors.black,
                                cursorWidth: 1.5,
                                showCursor: true,

                                decoration: InputDecoration(
                                  hintText: ' 가입되어 있는 이메일을 입력해 주세요.',
                                  hintStyle: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                  border: InputBorder.none,

                                  filled: true, // 배경을 채울지 여부 설정
                                  fillColor: const Color(0xFFF4F4F4), // 배경색 설정
                                  enabledBorder: OutlineInputBorder( // 활성 상태가 아닐 때의 경계선 스타일
                                    borderSide: const BorderSide(
                                      color: Colors.transparent, // 경계선 색상
                                      width: 0, // 경계선 너비
                                    ),
                                    borderRadius: BorderRadius.circular(50), // 경계선 모서리 둥글기 설정
                                  ),
                                  focusedBorder: OutlineInputBorder( // 활성 상태일 때의 경계선 스타일
                                    borderSide: const BorderSide(
                                      color: Colors.transparent, // 경계선 색상
                                      width: 0, // 경계선 너비
                                    ),
                                    borderRadius: BorderRadius.circular(50), // 경계선 모서리 둥글기 설정
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        // 클릭 이벤트에 따른 로직 작성
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFC7C7CC), // 배경색
                                          borderRadius: BorderRadius.circular(30),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.2), // 그림자 색상
                                              spreadRadius: 1, // 그림자 확산 범위
                                              blurRadius: 2, // 그림자 흐림 정도
                                              offset: const Offset(0, 3), // 그림자 위치 (x, y)
                                            ),
                                          ],
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                        child: const Text(
                                          '취소',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                  ),

                                  const SizedBox(width: 10),

                                  InkWell(
                                      onTap: () {
                                        // 클릭 이벤트에 따른 로직 작성
                                        bottomState((){
                                          setState(() async {
                                            _storedValue = _controller.text;
                                            if(condition1 == false) {
                                              Fluttertoast.showToast(
                                                msg: '처리사항 안내 확인에 동의해 주세요.',
                                                toastLength: Toast.LENGTH_SHORT,
                                                backgroundColor: Colors.grey,
                                                textColor: Colors.white,
                                                fontSize: 16.0,
                                              );
                                            }
                                            else if(_storedValue == userEmail) {
                                              condition2 = true;
                                              if(condition1 && condition2) {
                                                //--- 탈퇴 처리 구현부 ---
                                                bool isAuthSuccess = await FirebaseAuthService().deleteAuth();
                                                bool isStoreSuccess = await FirebaseStoreService().deleteUserInfo(userId);
                                                if(isAuthSuccess && isStoreSuccess){
                                                  _controller.clear();
                                                  Fluttertoast.showToast(
                                                  msg: '탈퇴 되었습니다.',
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  backgroundColor: Colors.grey,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0,
                                                  );
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => const LoginScreen(), // 이동할 페이지 위젯
                                                    ),
                                                  );
                                                } else {
                                                    Fluttertoast.showToast(
                                                    msg: '회원 탈퇴 실패',
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    backgroundColor: Colors.grey,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0,
                                                  );
                                                }
                                              } 
                                            } else {
                                                    Fluttertoast.showToast(
                                                    msg: '이메일이 일치하지 않습니다.',
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    backgroundColor: Colors.grey,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0,
                                                  );
                                                }
                                          });
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF176FF2), // 배경색
                                          borderRadius: BorderRadius.circular(30),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.2), // 그림자 색상
                                              spreadRadius: 1, // 그림자 확산 범위
                                              blurRadius: 2, // 그림자 흐림 정도
                                              offset: const Offset(0, 3), // 그림자 위치 (x, y)
                                            ),
                                          ],
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                        child: const Text(
                                          '확인',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void openNotificationSettings() {
    const intent = AndroidIntent(
      action: 'android.settings.APP_NOTIFICATION_SETTINGS',
    );
    intent.launch();
  }

  void openLocationSourceSettings() {
    const intent = AndroidIntent(
      action: 'android.settings.LOCATION_SOURCE_SETTINGS',
    );
    intent.launch();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    String userId = userProvider.firebaseUserId!;
    final FirebaseStoreService firebaseStoreService = FirebaseStoreService();
    Future<List<String>> userInfoListFuture = firebaseStoreService.getUserInfo(userId);
    
    return FutureBuilder<List<String>>(
      future: userInfoListFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            List<String> userInfoList = snapshot.data!;
    return Column(
      children: [
        const CustomHeader(
          name: '내 정보',
        ),
        Expanded(
          child: Container(
            color: const Color(0xFFF4F4F4),
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  height: 225,
                  child: Padding(
                    padding: getPadding(left: 20, right: 20),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 41,
                          child: Row(
                            children: [
                              Text(
                                //이름
                                userInfoList[0],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                         SizedBox(
                          height: 41,
                          child: Row(
                            children: [
                              Text(
                                //이메일
                                userInfoList[1],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        SizedBox(
                          height: 41,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "알림 권한 설정",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  openNotificationSettings();
                                },
                                child: const Icon(
                                  Icons.keyboard_arrow_right_rounded,
                                  color: Color(0xFF939191),
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        SizedBox(
                          height: 41,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "위치 권한 설정",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  openLocationSourceSettings();
                                },
                                child: const Icon(
                                  Icons.keyboard_arrow_right_rounded,
                                  color: Color(0xFF939191),
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                InkWell(
                  onTap: () {
                    // --- 회원 탈퇴 기능 구현부 ---
                    _showResignDialog(userInfoList[1], userId);
                  },
                  child: const Text(
                    '회원 탈퇴하기',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF939191),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  } else if (snapshot.hasError) {
            throw Exception('Widget cannot be null');
          }
        }
  return (
    const Center(
      child: SizedBox( width: 30, height: 30, child: CircularProgressIndicator()))
    );
  },
    );
  }
}