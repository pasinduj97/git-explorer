import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:git_explorer/services/forum_methods.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/forumComponents/text_field_input.dart';
import '../../services/storage_methods.dart';

class AddQuestionScreen extends StatefulWidget {
  final String question;
  final bool editMode;
  final String questionId;

  const AddQuestionScreen(
      {Key? key,
      this.question = '',
      this.editMode = false,
      this.questionId = ''})
      : super(key: key);

  @override
  _AddQuestionScreen createState() => _AddQuestionScreen();
}

class _AddQuestionScreen extends State<AddQuestionScreen> {
  final TextEditingController _questionController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    _questionController.dispose();
  }

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
    if (widget.editMode) {
      _questionController.text = widget.question;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff251F34),
        title: widget.editMode
            ? const Text('Edit Question')
            : const Text('Post Question'),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          color:   const Color(0xff251F34),
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
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                alignment: Alignment.centerLeft,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                textInputType: TextInputType.text,
                textEditingController: _questionController,
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
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
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
                                  decoration: const BoxDecoration(
                                      color: Color(0xfff3B324E),)
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
                    color: Color(0xff14DAE2),),
                ),
                onTap: () async {
                  setState(() {
                    _isLoading = true;
                  });

                  String photoUrl = '';
                  if (_image != null) {
                    photoUrl =
                        await StorageMethods().uploadImageToStorage(_image!);
                  }

                  if (widget.editMode) {
                    await ForumMethods().editQuestion(
                        newQuestion: _questionController.text,
                        newImage: photoUrl,
                        questionId: widget.questionId);
                  }

                  if (!widget.editMode) {
                    await ForumMethods().postQuestion(
                        question: _questionController.text, imageUrl: photoUrl);
                  }
                  setState(() {
                    _questionController.clear();
                    _image = null;
                    _isLoading = false;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
