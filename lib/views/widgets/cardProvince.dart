part of 'widgets.dart';

class CardProvince extends StatefulWidget {
  //inisiasi province
  final Province prov;
  const CardProvince(this.prov);

  @override
  State<CardProvince> createState() => _CardProvinceState();
}

class _CardProvinceState extends State<CardProvince>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Province p = widget.prov;
    return Card(
      color: Color(0xFFFFFFFF),
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0)
      ),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        // nampilin data dari API
        title: Text("${p.province}"),
        subtitle: Text("${p.province}"),
      ),
    );
  }
}