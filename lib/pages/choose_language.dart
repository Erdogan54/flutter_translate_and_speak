import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_translate_and_speak/cubit/translate_cubit.dart';
import 'package:image_loader/image_helper.dart';
import '../cubit/language_cubit.dart';
import '../models/language_model.dart';

class ChooseLanguagePage extends StatefulWidget {
  final String place;
  const ChooseLanguagePage({super.key, required this.place});

  @override
  State<ChooseLanguagePage> createState() => _ChooseLanguagePageState();
}

class _ChooseLanguagePageState extends State<ChooseLanguagePage> {
  late TextEditingController _controller;
  String? groupValue;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    groupValue = "filtre 1";
  }

  @override
  Widget build(BuildContext context) {
    context.read<LanguageCubit>().getLanguageList(context);
    _controller.text = context.read<LanguageCubit>().searchValue;

    return Scaffold(
        appBar: _appBar(context),
        body: BlocBuilder(
          bloc: BlocProvider.of<LanguageCubit>(context),
          builder: (context, state) {
            if (state is LangugaeListState) {
              return _body(context, state.languageList);
            } else {
              return _initialize();
            }
          },
        ));
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: !BlocProvider.of<LanguageCubit>(context).isSearch
          ? const Text("Select Language")
          : _search(context),
      actions: [
        IconButton(
            onPressed: () {
              BlocProvider.of<LanguageCubit>(context).isSearch = true;
              setState(() {});
            },
            icon: const Icon(Icons.search))
      ],
    );
  }

  Widget _search(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Center(
        child: TextField(
          controller: _controller,
          onChanged: (value) {
            context.read<LanguageCubit>().onSearch(value: value);
          },
          decoration: InputDecoration(
            suffixIcon: IconButton(
                onPressed: () {
                  _controller.text = "";
                  context.read<LanguageCubit>().onSearch(value: "");
                },
                icon: const Icon(Icons.clear)),
            hintText: "Enter language",
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _body(BuildContext context, List<LanguageModel> list) {
    context.read<LanguageCubit>().onSearch(value: _controller.text);

    return Column(
      children: [
        DefaultTextStyle(
          style: TextStyle(
            fontSize: 15,
            color: Colors.blueGrey.shade700,
          ),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                color: Colors.grey.shade50,
                boxShadow: const [
                  BoxShadow(color: Colors.black, blurRadius: 2)
                ]),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  InkWell(
                      onTap: () {
                        _showDialogFilter(context);
                      },
                      child: const Text("Filtrele")),
                  Container(
                    color: Colors.grey,
                    height: 20,
                    width: 1.2,
                  ),
                  InkWell(onTap: () {}, child: const Text("Sırala")),
                  Container(
                    color: Colors.grey,
                    height: 20,
                    width: 1.2,
                  ),
                  InkWell(onTap: () {}, child: const Text("Görünüm")),
                ]),
          ),
        ),
        const SizedBox(height: 5),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: SizedBox(
              height: 500,
              width: double.infinity,
              child: ListView.separated(
                addSemanticIndexes: true,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  LanguageModel model = list[index];
                  return InkWell(
                    onTap: () => _onTab(context, model),
                    child: _listItem(model, index),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    thickness: 2,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<dynamic> _showDialogFilter(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            actionsOverflowAlignment: OverflowBarAlignment.center,
            actionsOverflowButtonSpacing: 0,
            contentPadding: const EdgeInsets.all(16),
            scrollable: true,
            title: const Text("Filtreleme seçenekleri"),
            content: Column(
              children: [
                RadioListTile(
                    title: const Text("filtre 1"),
                    value: "filtre 1",
                    groupValue: groupValue,
                    onChanged: (value) {
                      setState(() {
                        debugPrint(value.toString());
                        groupValue = value.toString();
                      });
                    }),
                RadioListTile(
                    title: const Text("filtre 2"),
                    value: "filtre 2",
                    groupValue: groupValue,
                    onChanged: (value) {
                      setState(() {
                        debugPrint(value.toString());
                        groupValue = value.toString();
                      });
                    }),
                RadioListTile(
                    title: const Text("filtre 3"),
                    value: "filtre 3",
                    groupValue: groupValue,
                    onChanged: (value) {
                      setState(() {
                        debugPrint(value.toString());
                        groupValue = value.toString();
                      });
                    }),
              ],
            ),
          );
        });
  }

  void _onTab(BuildContext context, LanguageModel item) {
    if (widget.place == "from") {
      BlocProvider.of<TranslateCubit>(context).setFromLanguage(item);
    } else {
      BlocProvider.of<TranslateCubit>(context).setToLanguage(item);
    }
    Navigator.pop(context);
  }

  _listItem(LanguageModel model, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _countryImage(model),
            const SizedBox(width: 10),
            _textGroup(model),
            Text((index + 1).toString())
          ],
        ),
      ],
    );
  }

  _countryImage(LanguageModel item) {
    try {
      return ImageHelper(
        imageType: ImageType.network,
        image: item.imageAdress!,
        defaultLoaderColor: Colors.white,
        defaultErrorBuilderColor: Colors.blueGrey,
        boxFit: BoxFit.fill,
        imageShape: ImageShape.rectangle,
        height: 80,
        width: 120,
        blendMode: BlendMode.srcIn,
        boxBorder: Border.all(color: Colors.deepOrangeAccent, width: 1),
        errorBuilder: _errorBuilderIcon,
        loaderBuilder: _loader,
      );
    } on Exception catch (e) {
      debugPrint(e.toString());
      return _errorBuilderIcon;
    }
  }

  _textGroup(LanguageModel model) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(model.countries![0],
              style: TextStyle(
                  color: Colors.blue[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 22)),
          Text(model.language!,
              style: TextStyle(color: Colors.blue[500], fontSize: 18)),
          Visibility(
            visible: model.listenCode!.isEmpty,
            child: const Text("Konusma algılama desteklenmiyor",
                style: TextStyle(
                    color: Colors.redAccent, fontStyle: FontStyle.italic)),
          ),
          Visibility(
            visible: model.speakCode!.isEmpty,
            child: const Text("Dinleme desteklenmiyor",
                style: TextStyle(
                    color: Colors.redAccent, fontStyle: FontStyle.italic)),
          ),
        ],
      ),
    );
  }

  Widget get _loader => const SpinKitWave(
        color: Colors.redAccent,
        type: SpinKitWaveType.start,
      );

  Widget get _errorBuilderIcon => const Icon(
        Icons.image_not_supported,
      );

  Widget _initialize() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: const [
          CircularProgressIndicator(),
          SizedBox(
            height: 15,
          ),
          Text("Yükleniyor..."),
        ],
      ),
    );
  }
}
