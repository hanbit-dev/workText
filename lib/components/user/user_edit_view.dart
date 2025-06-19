import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worktext/services/user_service.dart';

/// 사용자 정보 수정 모달 컴포넌트
///
/// 사용 예시:
/// ```dart
/// showDialog(
///   context: context,
///   builder: (BuildContext context) {
///     return Dialog(
///       child: UserEditView(selectedUser: userService.user),
///     );
///   },
/// );
/// ```
///
/// 특징:
/// - user_nm: 읽기 전용 (수정 불가)
/// - birth_day: 수정 가능 (YYYY-MM-DD 형식)
/// - gender: 라디오 버튼으로 남성/여성 선택
/// - API는 UserService.updateUserInfo()로 추상화됨
class UserEditView extends StatefulWidget {
  final Map<String, dynamic>? selectedUser;
  const UserEditView({super.key, required this.selectedUser});

  @override
  _UserEditViewState createState() => _UserEditViewState();
}

class _UserEditViewState extends State<UserEditView> {
  late TextEditingController _userNameController;
  late TextEditingController _birthDayController;
  String _selectedGender = "M"; // 기본값: 남성
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();

    _userNameController =
        TextEditingController(text: widget.selectedUser?['user_nm'] ?? "-");

    // 기존 생년월일 데이터가 있으면 파싱해서 DateTime으로 변환
    String? existingBirthDay = widget.selectedUser?['birth_day'];
    if (existingBirthDay != null && existingBirthDay.isNotEmpty) {
      try {
        _selectedDate = DateTime.parse(existingBirthDay);
        _birthDayController =
            TextEditingController(text: _formatDate(_selectedDate!));
      } catch (e) {
        _birthDayController = TextEditingController(text: "");
      }
    } else {
      _birthDayController = TextEditingController(text: "");
    }

    _selectedGender = widget.selectedUser?['gender'] ?? "M";
  }

  @override
  void dispose() {
    // 메모리 누수 방지를 위해 컨트롤러 해제
    _userNameController.dispose();
    _birthDayController.dispose();
    super.dispose();
  }

  // 날짜를 YYYY-MM-DD 형태로 포맷팅
  String _formatDate(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  // 네이티브 달력 표시
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthDayController.text = _formatDate(picked);
      });
    }
  }

  // 사용자 정보 업데이트 함수 (추상화)
  Future<void> _updateUserInfo() async {
    final userService = Provider.of<UserService>(context, listen: false);

    // 선택된 날짜를 YYYY-MM-DD 형태로 포맷팅하여 API에 전송
    String birthDayForApi =
        _selectedDate != null ? _formatDate(_selectedDate!) : "";

    await userService.updateUserInfo(
      birthDayForApi,
      _selectedGender,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context, listen: true);
    final isUpdating = userService.isLoading;

    return Container(
      width: 700,
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Center(
                child: Column(
                  children: [
                    const Text("사용자 정보 수정",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24)),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                                width: 100,
                                child: Text("이름",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                            SizedBox(
                              width: 200,
                              child: TextField(
                                controller: _userNameController,
                                enabled: false, // readonly
                                decoration: InputDecoration(
                                  hintText: "사용자 이름",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                ),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const SizedBox(
                                width: 100,
                                child: Text("생년월일",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                            SizedBox(
                              width: 200,
                              child: TextField(
                                controller: _birthDayController,
                                readOnly: true, // 읽기 전용으로 설정
                                onTap: () => _selectDate(context), // 탭하면 달력 표시
                                decoration: InputDecoration(
                                  hintText: "생년월일을 선택하세요",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  suffixIcon: const Icon(
                                    Icons.calendar_today,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const SizedBox(
                                width: 100,
                                child: Text("성별",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Radio<String>(
                                      value: "M",
                                      groupValue: _selectedGender,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedGender = value ?? "M";
                                        });
                                      },
                                      activeColor:
                                          Colors.indigoAccent.withOpacity(0.8),
                                    ),
                                    const Text("남성"),
                                    const SizedBox(width: 20),
                                    Radio<String>(
                                      value: "W",
                                      groupValue: _selectedGender,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedGender = value ?? "M";
                                        });
                                      },
                                      activeColor:
                                          Colors.indigoAccent.withOpacity(0.8),
                                    ),
                                    const Text("여성"),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Spacer(),
                            ElevatedButton(
                              onPressed: isUpdating
                                  ? null
                                  : () async {
                                      await _updateUserInfo();
                                      Navigator.pop(context);
                                    },
                              child: isUpdating
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text("수정"),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: isUpdating
                                  ? null
                                  : () => {Navigator.pop(context)},
                              child: isUpdating
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text("닫기"),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
