part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Province> provinceData = [];

  bool isLoading = false;

  String? selectedService;
  dynamic cityDataOrigin;
  dynamic cityIdOrigin;
  dynamic selectedCityOrigin;

  Future<dynamic> getProvinces() async {
    await MasterDataService.getProvince().then((value) {
      setState(() {
        provinceData = value;
        isLoading = false;
      });
    });
  }

  Future<List<City>> getCities(var provId) async {
    dynamic city;
    await MasterDataService.getCity(provId).then((value) {
      setState(() {
        city = value;
      });
    });

    return city;
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    getProvinces();
    cityDataOrigin = getCities("5");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Hitung Ongkir"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10), // Spacer
                  Text("Service Name"),
                  Container(
                    width: double.infinity,
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedService,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 30,
                      elevation: 4,
                      style: TextStyle(color: Colors.black),
                      hint: const Text('Select service'),
                      items: [
                        DropdownMenuItem(
                          value: 'jne',
                          child: const Text('JNE'),
                        ),
                        DropdownMenuItem(
                          value: 'jnt',
                          child: const Text('JNT'),
                        ),
                        DropdownMenuItem(
                          value: 'pos',
                          child: const Text('POS'),
                        ),
                      ],
                      onChanged: (newValue) {
                        setState(() {
                          selectedService = newValue!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 10), // Spacer
                  Text("Weight (gram)"),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Weight",
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), // Spacer
                  Text("Origin"),
                  Container(
                    width: double.infinity,
                    child: FutureBuilder<List<City>>(
                      future: cityDataOrigin,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return DropdownButton(
                            isExpanded: true,
                            value: selectedCityOrigin,
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 30,
                            elevation: 4,
                            style: TextStyle(color: Colors.black),
                            hint: selectedCityOrigin == null
                                ? const Text('Pilih kota')
                                : Text(selectedCityOrigin.cityName),
                            items: snapshot.data!
                                .map<DropdownMenuItem<City>>(
                                  (City value) => DropdownMenuItem(
                                    value: value,
                                    child: Text(value.cityName.toString()),
                                  ),
                                )
                                .toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedCityOrigin = newValue;
                                cityIdOrigin = selectedCityOrigin.cityId;
                              });
                            },
                          );
                        } else if (snapshot.hasError) {
                          return const Text("Tidak ada data");
                        }
                        return UiLoading.loadingSmall();
                      },
                    ),
                  ),
                  const SizedBox(height: 10), // Spacer
                  Text("Destination"),
                  Container(
                    width: double.infinity,
                    child: FutureBuilder<List<City>>(
                      future: cityDataOrigin,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return DropdownButton(
                            isExpanded: true,
                            value: selectedCityOrigin,
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 30,
                            elevation: 4,
                            style: TextStyle(color: Colors.black),
                            hint: selectedCityOrigin == null
                                ? const Text('Pilih kota')
                                : Text(selectedCityOrigin.cityName),
                            items: snapshot.data!
                                .map<DropdownMenuItem<City>>(
                                  (City value) => DropdownMenuItem(
                                    value: value,
                                    child: Text(value.cityName.toString()),
                                  ),
                                )
                                .toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedCityOrigin = newValue;
                                cityIdOrigin = selectedCityOrigin.cityId;
                              });
                            },
                          );
                        } else if (snapshot.hasError) {
                          return const Text("Tidak ada data");
                        }
                        return UiLoading.loadingSmall();
                      },
                    ),
                  ),
                  const SizedBox(height: 20), // Spacer
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 24.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      elevation: 4,
                      primary: Colors.blue,
                    ),
                    child: const Text(
                      "Cek Ongkir",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Spacer
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      child: provinceData.isEmpty
                          ? const Align(
                              alignment: Alignment.center,
                              child: Text("Data tidak ditemukan"),
                            )
                          : ListView.builder(
                              itemCount: provinceData.length,
                              itemBuilder: (context, index) {
                                return CardProvince(provinceData[index]);
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading) UiLoading.loadingBlock(),
        ],
      ),
    );
  }
}
