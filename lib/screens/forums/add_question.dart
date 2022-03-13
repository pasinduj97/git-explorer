import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../components/forumComponents/text_field_input.dart';

class AddQuestionScreen extends StatefulWidget {
  const AddQuestionScreen({Key? key}) : super(key: key);

  @override
  _AddQuestionScreen createState() => _AddQuestionScreen();
}

class _AddQuestionScreen extends State<AddQuestionScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  // void signUpUser() async {
  //   // set loading to true
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   // signup user using our authmethodds
  //   String res = await AuthMethods().signUpUser(
  //       email: _emailController.text,
  //       password: _passwordController.text,
  //       username: _usernameController.text,
  //       bio: _bioController.text,
  //       file: _image!);
  //   // if string returned is sucess, user has been created
  //   if (res == "success") {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     // navigate to the home screen
  //     Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(
  //         builder: (context) => const ResponsiveLayout(
  //           mobileScreenLayout: MobileScreenLayout(),
  //           webScreenLayout: WebScreenLayout(),
  //         ),
  //       ),
  //     );
  //   } else {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     // show the error
  //     showSnackBar(context, res);
  //   }
  // }

  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    }
    print('No Image Selected');
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Question'),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 24,
              ),
              const Align(
                child: Text(
                  "Enter your question",
                  style: TextStyle(fontSize: 18),
                ),
                alignment: Alignment.centerLeft,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                textInputType: TextInputType.text,
                textEditingController: _usernameController,
                maxLines: 15,
              ),
              const SizedBox(
                height: 24,
              ),
              Stack(
                children: [
                  _image != null
                      ? InkWell(
                          onTap: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Remove Attachment'),
                              content: const Text(
                                  'Are you sure you want to remove the attachment'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'No'),
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, 'Yes');
                                    setState(() {
                                      _image = null;
                                    });
                                  },
                                  child: const Text('Yes'),
                                ),
                              ],
                            ),
                          ),
                          child: SizedBox(
                            height: 200.0,
                            width: 200.0,
                            child: AspectRatio(
                              aspectRatio: 487 / 451,
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  fit: BoxFit.fill,
                                  alignment: FractionalOffset.topCenter,
                                  image: MemoryImage(_image!),
                                )),
                              ),
                            ),
                          ),
                        )
                      : Column(
                        children: [
                          const Align(
                            child: Text(
                              "Attach image",
                              style: TextStyle(fontSize: 18),
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                          const SizedBox(height: 20,),
                          InkWell(
                              onTap: selectImage,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: double.infinity,
                                  height: 100,
                                  child: const Icon(
                                    Icons.add_a_photo,
                                    color: Colors.white,
                                  ),
                                  decoration: const ShapeDecoration(
                                      color: Colors.grey,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)))),
                                ),
                              ),
                            ),
                        ],
                      )
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                child: Container(
                  child: !_isLoading
                      ? const Text(
                          'Post',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        )
                      : const CircularProgressIndicator(color: Colors.white),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      color: Colors.blue),
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
