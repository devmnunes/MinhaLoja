import 'package:flutter/material.dart';
import '../services/location_service.dart';
 
class CityLine extends StatefulWidget {
  const CityLine({super.key});
 
  @override
  State<CityLine> createState() => _CityLineState();
}
 
class _CityLineState extends State<CityLine> {
  String? _city;
  bool _loading = true;
 
  @override
  void initState() {
    super.initState();
    _load();
  }
 
  Future<void> _load() async {
    try {
      final city = await LocationService.getCurrentCity();
      if (!mounted) return;
      setState(() {
        _city = city;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }
 
  @override
  Widget build(BuildContext context) {
    final text = _loading
        ? 'Detectando sua localização...'
        : (_city == null ? 'Localização indisponível' : 'Você está em: $_city');
 
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color.fromARGB(255, 2, 2, 2)),
      overflow: TextOverflow.ellipsis,
    );
  }
}