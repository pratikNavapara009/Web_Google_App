import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Web_App(),
    ),
  );
}

class Web_App extends StatefulWidget {
  const Web_App({Key? key}) : super(key: key);

  @override
  State<Web_App> createState() => _Web_AppState();
}

class _Web_AppState extends State<Web_App> {
  InAppWebViewController? inAppWebViewController;

  late PullToRefreshController pullToRefreshController;

  List<String> allBookmrks = [];

  @override
  void initState() {
    super.initState();
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(color: Colors.blue),
      onRefresh: () async {
        await inAppWebViewController?.reload();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            await inAppWebViewController?.goBack();
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            size: 28,
          ),
        ),
        title: IconButton(
          onPressed: () async {
            await inAppWebViewController?.reload();
          },
          icon: const Icon(
            Icons.refresh,
            size: 28,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              Uri? uri = await inAppWebViewController?.getUrl();

              String url = uri.toString();

              allBookmrks.add(url);
            },
            icon: const Icon(
              Icons.bookmark_border,
              size: 28,
            ),
          ),
          IconButton(
            onPressed: () async {
              await inAppWebViewController?.loadUrl(
                urlRequest: URLRequest(
                  url: Uri.parse("https://www.google.co.in"),
                ),
              );
            },
            icon: const Icon(
              Icons.home,
              size: 28,
            ),
          ),
          IconButton(
            onPressed: () async {
              await inAppWebViewController?.goForward();
            },
            icon: const Icon(
              Icons.arrow_forward_rounded,
              size: 28,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.grey.shade100,
              title: const Center(
                child: Text("Bookmark Added"),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: allBookmrks
                    .map(
                      (e) => GestureDetector(
                        onTap: () async {
                          Navigator.of(context).pop();
                          await inAppWebViewController?.loadUrl(
                            urlRequest: URLRequest(
                              url: Uri.parse(e),
                            ),
                          );
                        },
                        child: Text(
                          e,
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          );
        },
        child: const Icon(
          Icons.bookmark,
          size: 28,
        ),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: Uri.parse("https://www.google.co.in"),
        ),
        onWebViewCreated: (controller) {
          setState(
            () {
              inAppWebViewController = controller;
            },
          );
        },
        pullToRefreshController: pullToRefreshController,
        onLoadStop: (controller, url) async {
          await pullToRefreshController.endRefreshing();
        },
      ),
    );
  }
}
