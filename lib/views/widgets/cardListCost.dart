part of 'widgets.dart';

class cardListCost extends StatefulWidget {
  final Costs cost;
  const cardListCost(this.cost);

  @override
  State<cardListCost> createState() => _cardListCostState();
}

class _cardListCostState extends State<cardListCost> {
  @override
  Widget build(BuildContext context) {
    // mengambil data dari API (model)
    Costs cost = widget.cost;
    return Card(
        child: ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Image.asset("assets/images/logo.png"),
      ),
      title: Text("${cost.description} (${cost.service})}"),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for(var i in cost.cost ?? [])
            Text("Biaya: Rp.${i.value},00" ),
          

           for(var i in cost.cost ??[])
            Text("Estimasi Sampai: Rp.${i.etd} Hari" ),
          

        ],
      ),
    ));
  }
}
