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
    Costs cost = widget.cost;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            15.0), // Sesuaikan angka radius sesuai keinginan
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Image.asset("assets/images/Beat-patah.png"),
        ),
        title: Text("${cost.description} (${cost.service})"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i in cost.cost ?? [])
              Text(
                "Biaya: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(i.value)}",
              ),
            for (var i in cost.cost ?? [])
              Text("Estimasi Sampai: Rp.${i.etd} Hari"),
          ],
        ),
      ),
    );
  }
}
