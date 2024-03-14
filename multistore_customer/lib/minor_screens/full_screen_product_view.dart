import 'package:flutter/material.dart';

class FullScreenProductView extends StatefulWidget {
  final List<dynamic> imageList;
  const FullScreenProductView({super.key, required this.imageList});

  @override
  State<FullScreenProductView> createState() => _FullScreenProductViewState();
}

class _FullScreenProductViewState extends State<FullScreenProductView> {
  var index = 0;
  @override
  Widget build(BuildContext context) {
    final PageController _controller = PageController();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
              child: Text(
                "${index + 1} / ${widget.imageList.length}",
                style: const TextStyle(fontSize: 26),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: PageView(
                controller: _controller,
                onPageChanged: (value) {
                  setState(() {
                    index = value;
                  });
                },
                children: List.generate(
                  widget.imageList.length,
                  (index) {
                    return InteractiveViewer(
                      transformationController: TransformationController(),
                      child: Image.network(
                        widget.imageList[index],
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.imageList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _controller.jumpToPage(index);
                    },
                    child: Container(
                      width: 120,
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(width: 4, color: Colors.grey),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          widget.imageList[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
