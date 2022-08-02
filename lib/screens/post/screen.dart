import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/core/disposable_vm/disposable_vm.dart';
import 'package:test_project/core/sync_bloc/sync_bloc_error_listener.dart';
import 'package:test_project/network/models/comment.dart';
import 'package:test_project/network/models/post.dart';
import 'package:test_project/network/models/user.dart';
import 'package:test_project/repositories/posts_repository.dart';
import 'package:test_project/screens/post/bloc/comments_bloc.dart';
import 'package:test_project/screens/post/bloc/send_comment_bloc.dart';
import 'package:test_project/screens/post/widgets/comment_widget.dart';
import 'package:test_project/ui/post_card.dart';

class PostVM extends DisposableVM {
  final String postId;
  late final CommentsSyncBloc commentsSyncBloc;
  late final SendCommentSyncBloc sendCommentSyncBloc;
  late final TextEditingController commentController;
  late final TextEditingController emailController;
  late final TextEditingController nameController;

  PostVM(this.postId) {
    final repo = PostsRepositoryImpl();
    commentsSyncBloc = CommentsSyncBloc(postsRepository: repo);
    sendCommentSyncBloc = SendCommentSyncBloc(postsRepository: repo);

    commentsSyncBloc.add(CommentFetchEvent(postId: postId));

    commentController = TextEditingController();
    emailController = TextEditingController();
    nameController = TextEditingController();

    add(() {
      commentsSyncBloc.close();
      sendCommentSyncBloc.close();
      commentController.dispose();
      emailController.dispose();
      nameController.dispose();
    });
  }

  BuiltList<Comment> get comments {
    assert(commentsSyncBloc.state.data != null, 'no data in commentsSyncBloc');
    return commentsSyncBloc.state.data!;
  }

  bool get commentsSyncing =>
      commentsSyncBloc.state.syncing || !commentsSyncBloc.state.hadSync;

  bool get sendCommentSyncing => sendCommentSyncBloc.state.syncing;

  void sendComment() {
    sendCommentSyncBloc.add(
      SendCommentFetchEvent(
        postId: postId,
        name: nameController.text,
        email: emailController.text,
        comment: commentController.text,
      ),
    );
  }

  void clearCommentFields() {
    nameController.clear();
    emailController.clear();
    commentController.clear();
  }
}

class PostScreen extends StatefulWidget {
  final User user;
  final Post post;

  const PostScreen({
    Key? key,
    required this.user,
    required this.post,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => PostScreenState();
}

class PostScreenState extends State<PostScreen> {
  late final PostVM _vm;

  @override
  void initState() {
    super.initState();
    _vm = PostVM(widget.post.id.toString());

    // on successful send comment
    final sendCommentSubscription =
        _vm.sendCommentSyncBloc.stream.listen((state) {
      if (!state.syncing && state.data != null) {
        Navigator.of(context).pop();
        _vm.clearCommentFields();
      }
    });
    _vm.add(() => sendCommentSubscription.cancel());
  }

  @override
  void dispose() {
    super.dispose();
    _vm.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('${widget.user.username}\'s Posts'),
      ),
      body: MultiSyncBlocErrorsListener(
        blocs: [
          _vm.sendCommentSyncBloc,
          _vm.commentsSyncBloc,
        ],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder(
            bloc: _vm.commentsSyncBloc,
            builder: (context, _) {
              if (_vm.commentsSyncing) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (_vm.commentsSyncBloc.state.hasOnlyError) {
                return Center(
                  child: Text(
                    'Ошибка синхронизации.\n${_vm.commentsSyncBloc.state.lastSyncError}',
                  ),
                );
              }

              return ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  PostCard(title: widget.post.title, body: widget.post.body),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Comments',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const Divider(
                            thickness: 2,
                          ),
                          ..._vm.comments.map(
                            (comment) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommentWidget(comment: comment),
                                const Divider(
                                  thickness: 2,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _showAddCommentBottomSheet(),
                    child: const Text('Add Comment'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showAddCommentBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return BlocBuilder(
            bloc: _vm.sendCommentSyncBloc,
            builder: (context, _) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 4),
                    TextField(
                      enabled: !_vm.sendCommentSyncing,
                      decoration: const InputDecoration(
                        hintText: 'Name',
                        contentPadding: EdgeInsets.all(10),
                        enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                      ),
                      controller: _vm.nameController,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      enabled: !_vm.sendCommentSyncing,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        contentPadding: EdgeInsets.all(10),
                        enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                      ),
                      controller: _vm.emailController,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      enabled: !_vm.sendCommentSyncing,
                      decoration: const InputDecoration(
                        hintText: 'Message',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 40, horizontal: 10),
                        enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                      ),
                      controller: _vm.commentController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () =>
                              _vm.sendCommentSyncing ? null : _vm.sendComment(),
                          child: _vm.sendCommentSyncing
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Send'),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });
      },
    );
  }
}
