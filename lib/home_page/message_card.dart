import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/APIs/apis.dart';
import 'package:chat_app/helper/dialog.dart';
import 'package:chat_app/helper/my_date_util.dart';
import 'package:chat_app/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({Key? key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.user.uid == widget.message.fromId;
    return InkWell(
        onLongPress: () {
          _showBottomSheet(isMe);
        },
        child: isMe ? _greenMessage() : _blueMessage());
  }

  Widget _blueMessage() {
    if (widget.message.read.isNotEmpty) {
      APIs.updateMessageReadStatus(widget.message);
      print('message read updated');
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 220, // Set your desired maximum width here
              ),
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.message.type == Type.text
                        ? Text(
                            widget.message.msg,
                            style: const TextStyle(
                              fontSize: 19,
                              color: Colors.black,
                              fontFamily: 'Mulish',
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              imageUrl: widget.message.msg,
                              placeholder: (context, url) => const Padding(
                                padding: EdgeInsets.all(0.0),
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.image, size: 70),
                            ),
                          ),
                    const SizedBox(height: 10),
                    Text(
                      MyDateUtil.getFormattedTime(
                        context: context,
                        time: widget.message.sent,
                      ),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFFADB5BD),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _greenMessage() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 220, // Set your desired maximum width here
              ),
              child: Container(
                padding:
                    EdgeInsets.all(widget.message.type == Type.image ? 15 : 15),
                decoration: BoxDecoration(
                  color: Color(0xFF375FFF),
                  border: Border.all(color: Colors.lightBlue),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.message.type == Type.text
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 1),
                            child: Text(
                              widget.message.msg,
                              style: const TextStyle(
                                fontSize: 19,
                                color: Colors.white,
                                fontFamily: 'Mulish',
                              ),
                            ),
                          )
                        //show image
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              imageUrl: widget.message.msg,
                              placeholder: (context, url) => const Padding(
                                padding: EdgeInsets.all(0.0),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child:
                                      CircularProgressIndicator(strokeWidth: 1),
                                ),
                              ),
                              errorWidget: (context, url, error) {
                                print('Error loading image: $error');
                                return const Icon(Icons.error,
                                    size: 70, color: Colors.red);
                              },
                            ),
                          ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: Text(
                        MyDateUtil.getFormattedTime(
                          context: context,
                          time: widget.message.sent,
                        ),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

//modify message details
  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              //black divider

              widget.message.type == Type.text
                  ?
                  //copy option
                  _OptionItem(
                      icon: const Icon(Icons.copy_all_rounded,
                          color: Colors.blue, size: 26),
                      name: 'Copy Text',
                      onTap: () async {
                        await Clipboard.setData(
                                ClipboardData(text: widget.message.msg))
                            .then((value) {
                          //for hiding bottom sheet
                          Navigator.pop(context);

                          Dialogs.showSnackbar(context, 'Text Copied!');
                        });
                      })
                  :
                  //save option
                  _OptionItem(
                      icon: const Icon(Icons.download_rounded,
                          color: Colors.blue, size: 26),
                      name: 'Save Image',
                      onTap: () async {
                        try {
                          print('Image Url: ${widget.message.msg}');
                          await GallerySaver.saveImage(widget.message.msg,
                                  albumName: 'We Chat')
                              .then((success) {
                            //for hiding bottom sheet
                            Navigator.pop(context);
                            if (success != null && success) {
                              Dialogs.showSnackbar(
                                  context, 'Image Successfully Saved!');
                            }
                          });
                        } catch (e) {
                          print('ErrorWhileSavingImg: $e');
                        }
                      }),

              //separator or divider
              if (isMe)
                Divider(
                  color: Colors.black54,
                  endIndent: 30,
                  indent: 30,
                ),

              //edit option
              if (widget.message.type == Type.text && isMe)
                _OptionItem(
                    icon: const Icon(Icons.edit, color: Colors.blue, size: 26),
                    name: 'Edit Message',
                    onTap: () {
                      //for hiding bottom sheet
                      Navigator.pop(context);

                      _showMessageUpdateDialog();
                    }),

              //delete option
              if (isMe)
                _OptionItem(
                    icon: const Icon(Icons.delete_forever,
                        color: Colors.red, size: 26),
                    name: 'Delete Message',
                    onTap: () async {
                      await APIs.deleteMessage(widget.message).then((value) {
                        //for hiding bottom sheet
                        Navigator.pop(context);
                      });
                    }),

              //separator or divider
              Divider(
                color: Colors.black54,
                endIndent: 30,
                indent: 30,
              ),

              //sent time
              _OptionItem(
                  icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                  name:
                      'Sent At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.sent)}',
                  onTap: () {}),

              //read time
              _OptionItem(
                  icon: const Icon(Icons.remove_red_eye, color: Colors.green),
                  name: widget.message.read.isEmpty
                      ? 'Read At: Not seen yet'
                      : 'Read At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.read)}',
                  onTap: () {}),
            ],
          );
        });
  }

  //dialog for updating message content
  void _showMessageUpdateDialog() {
    String updatedMsg = widget.message.msg;

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),

              //title
              title: Row(
                children: const [
                  Icon(
                    Icons.message,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text(' Update Message')
                ],
              ),

              //content
              content: TextFormField(
                initialValue: updatedMsg,
                maxLines: null,
                onChanged: (value) => updatedMsg = value,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),

              //actions
              actions: [
                //cancel button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    )),

                //update button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                      APIs.updateMessage(widget.message, updatedMsg);
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            ));
  }
}

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
          child: Row(children: [
            icon,
            Flexible(
                child: Text('    $name',
                    style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        letterSpacing: 0.5)))
          ]),
        ));
  }
}
