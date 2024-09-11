import 'package:flutter/material.dart';
import 'package:worktext/services/user_service.dart';

class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AdditionalUserInfoPage(),
    );
  }
}

class AdditionalUserInfoPage extends StatefulWidget {
  const AdditionalUserInfoPage({super.key});

  @override
  _AdditionalUserInfoPageState createState() => _AdditionalUserInfoPageState();
}

class _AdditionalUserInfoPageState extends State<AdditionalUserInfoPage> {
  final UserService _userService = UserService();
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _gender = '남성';
  String _ageGroup = '20대';

  final List<String> _genderOptions = ['남성', '여성'];
  final List<String> _ageGroupOptions = ['10대', '20대', '30대', '40대', '50대 이상'];

  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void _loadUserInfo() async {
    final userInfo = await _userService.getUserInfo();
    if (userInfo != null) {
      setState(() {
        _name = userInfo['name'] ?? '';
        _gender = userInfo['gender'] ?? '남성';
        _ageGroup = userInfo['ageGroup'] ?? '20대';
        _nameController.text = _name;
      });
    }
  }

  void _saveUserInfo() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await _userService.saveAdditionalUserInfo(
        name: _name,
        gender: _gender,
        ageGroup: _ageGroup,
      );

      if (mounted) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 535,
            padding: const EdgeInsets.all(30),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '추가 정보 입력',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: '이름',
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '이름을 입력해주세요';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _name = value!;
                        },
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: '성별',
                          filled: true,
                        ),
                        value: _gender,
                        items: _genderOptions.map((String gender) {
                          return DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _gender = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: '연령대',
                          filled: true,
                        ),
                        value: _ageGroup,
                        items: _ageGroupOptions.map((String ageGroup) {
                          return DropdownMenuItem(
                            value: ageGroup,
                            child: Text(ageGroup),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _ageGroup = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _saveUserInfo,
                          child: const Text('저장'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
