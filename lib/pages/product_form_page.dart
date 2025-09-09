

import 'package:flutter/material.dart';
import 'package:loja/models/product.dart';
import 'package:provider/provider.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();

  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(updateImage);
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus.removeListener(updateImage);
    _imageUrlFocus.dispose();
  }

  void updateImage() {
    setState(() {});
  }

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endsWithFile =
        url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');
    return isValidUrl && endsWithFile;
  }

  void _submitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    
    Provider.of(context, listen: false).addProductFromData(_formData);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Produto'),
        actions: [
          IconButton(
            onPressed: () {
              _submitForm();
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nome',
                  labelStyle: TextStyle(
                    color: const Color.fromARGB(255, 128, 127, 127),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocus);
                },
                onSaved: (nome) => _formData['nome'] = nome ?? '-',
                validator: (_nome) {
                  final nome = _nome ?? '';

                  if (nome.trim().isEmpty) {
                    return 'Nome do produto é obrigatório';
                  }

                  if (nome.trim().length < 3) {
                    return 'Nome precisa no mínimo 3 letras';
                  }
                  return null;
                },
              ),

              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Preço',
                  labelStyle: TextStyle(
                    color: const Color.fromARGB(255, 128, 127, 127),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                textInputAction: TextInputAction.next,
                focusNode: _priceFocus,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocus);
                },
                onSaved: (preco) =>
                    _formData['preço'] = double.parse(preco ?? '0'),
                    validator: (_preco) {
                      final precoString = _preco ?? '-1';
                      final preco = double.tryParse(precoString) ?? -1;

                      if (preco <= 0) {
                        return 'Preço inválido';
                      }
                      return null;
                    },
              ),

              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  labelStyle: TextStyle(
                    color: const Color.fromARGB(255, 128, 127, 127),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                textInputAction: TextInputAction.next,
                focusNode: _descriptionFocus,
                maxLines: 2,
                onSaved: (descicao) => _formData['descrição'] = descicao ?? '-',
                validator: (_descricao) {
                  final descricao = _descricao ?? '';

                  if (descricao.trim().isEmpty) {
                    return 'Descrição do produto é obrigatório';
                  }

                  if (descricao.trim().length < 8) {
                    return 'Nome precisa no mínimo 3 letras';
                  }
                  return null;
                },
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Url da Imagem',
                        labelStyle: TextStyle(
                          color: const Color.fromARGB(255, 128, 127, 127),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                      focusNode: _imageUrlFocus,
                      controller: _imageUrlController,
                      keyboardType: TextInputType.url,
                      onFieldSubmitted: (_) => _submitForm(),
                      onSaved: (imageUrl) =>
                          _formData['imageUrl'] = imageUrl ?? '-',
                      validator: (_imageUrl) {
                        final imageUrl = _imageUrl ?? '';
                        if (!isValidImageUrl(imageUrl)) {
                          return 'Informe uma Url válida';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    height: 105,
                    width: 105,
                    margin: EdgeInsets.only(top: 10, left: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    alignment: Alignment.center,
                    child: _imageUrlController.text.isEmpty
                        ? Text('Informe a Url')
                        : FittedBox(
                            child: Image.network(_imageUrlController.text),
                            fit: BoxFit.cover,
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
