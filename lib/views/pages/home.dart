part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List<Province> provinceData = [];

  ///
  bool isLoading = false;

  Future<List<Province>> getProvinces() async {
    ////
    dynamic temp;
    await MasterDataService.getProvince().then((value) {
      setState(() {
        temp = value;

        ///
        isLoading = false;
      });
    });
    return temp;
  }

  //
  bool isCek = false;

  List<Costs> updatedCost = [];
  // Province
  dynamic selectedProvinceOrigin;
  dynamic selectedProvinceDestination;
  dynamic provinceData;

  // City
  dynamic cityIdOrigin;
  dynamic cityIdDestination;
  dynamic cityDataOrigin;
  dynamic cityDataDestination;
  dynamic selectedCityOrigin;
  dynamic selectedCityDestination;

  // kurir
  dynamic selectedKurir;
  TextEditingController beratBarang = TextEditingController();

  Future<List<City>> getCities(var provId) async {
    ////
    dynamic city;
    await MasterDataService.getCity(provId).then((value) {
      setState(() {
        city = value;
      });
    });

    return city;
  }

  Future<List<Costs>> getCosts(
      var originId, var destinationId, var weight, var courier) async {
    try {
      List<Costs> costs = await MasterDataService.getCosts(
          originId, destinationId, weight, courier);

      return costs;
    } catch (e) {
      print(e);
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getProvinces();
    // mengambil data dari function getProvinces
    provinceData = getProvinces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Home Page"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Flexible(
                flex: 3,
                child: Container(
                  margin: EdgeInsets.all(20),
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    children: [
                      // List jasa pengiriman & berat
                      Row(
                        children: [
                          // dropdown jasa pengiriman
                          Expanded(
                            flex: 1,
                            child: DropdownButton(
                              isExpanded: true,
                              value: selectedKurir,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 30,
                              elevation: 4,
                              style: TextStyle(color: Colors.black),
                              hint: Text('Pilih salah satu'),
                              items: [
                                DropdownMenuItem(
                                    value: "jne", child: Text("JNE")),
                                DropdownMenuItem(
                                    value: "tiki", child: Text("TIKI")),
                                DropdownMenuItem(
                                    value: "pos", child: Text("POS")),
                              ],
                              onChanged: (newValue) {
                                setState(() {
                                  selectedKurir = newValue;
                                  // Mencetak nilai yang dipilih ke konsol
                                  print(selectedKurir);
                                });
                              },
                            ),
                          ),

                          // input berat
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller: beratBarang,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]'),
                                ),
                              ],
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                label: Text("berat"),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // dropdown Origin
                      Align(
                          alignment: Alignment.topLeft, child: Text("Origin")),
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: FutureBuilder<List<Province>>(
                                future: provinceData,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return DropdownButton(
                                        isExpanded: true,
                                        // simpan data di variable
                                        value: selectedProvinceOrigin,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 30,
                                        elevation: 4,
                                        style: TextStyle(color: Colors.black),
                                        hint: selectedProvinceOrigin == null
                                            ? Text('Pilih Provinsi')
                                            : Text(selectedProvinceOrigin
                                                .province),
                                        items: snapshot.data!
                                            .map<DropdownMenuItem<Province>>(
                                                (Province value) {
                                          return DropdownMenuItem(
                                              value: value,
                                              child: Text(
                                                  value.province.toString()));
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedProvinceOrigin = newValue;
                                            // mengambil data kota
                                            cityDataOrigin = getCities(
                                                selectedProvinceOrigin
                                                    .provinceId);
                                          });
                                        });
                                  } else if (snapshot.hasError) {
                                    return Text("Tidak ada data");
                                  }
                                  return UiLoading.loadingSmall();
                                }),
                          ),
                          Flexible(
                            flex: 1,
                            child: FutureBuilder<List<City>>(
                                future: cityDataOrigin,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return UiLoading.loadingSmall();
                                  }

                                  if (snapshot.hasData) {
                                    return DropdownButton(
                                        isExpanded: true,
                                        value: selectedCityOrigin,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 30,
                                        elevation: 4,
                                        style: TextStyle(color: Colors.black),
                                        hint: selectedCityOrigin == null
                                            ? Text('Pilih kota')
                                            : Text(selectedCityOrigin.cityName),
                                        items: snapshot.data!
                                            .map<DropdownMenuItem<City>>(
                                                (City value) {
                                          return DropdownMenuItem(
                                              value: value,
                                              child: Text(
                                                  value.cityName.toString()));
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedCityOrigin = newValue;
                                            cityIdOrigin =
                                                selectedCityOrigin.cityId;
                                          });
                                        });
                                  } else if (snapshot.hasError) {
                                    return Text("Tidak ada data");
                                  }

                                  return DropdownButton(
                                      isExpanded: true,
                                      value: selectedCityOrigin,
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 30,
                                      elevation: 4,
                                      style: TextStyle(color: Colors.black),
                                      items: [],
                                      onChanged: (value) {
                                        Null;
                                      },
                                      isDense: false,
                                      hint: Text("Pilih kota"),
                                      disabledHint: Text("Pilih kota"));
                                }),
                          )
                        ],
                      ),

                      // dropdown Destination
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: FutureBuilder<List<Province>>(
                                future: provinceData,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return DropdownButton(
                                        isExpanded: true,
                                        value: selectedProvinceDestination,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 30,
                                        elevation: 4,
                                        style: TextStyle(color: Colors.black),
                                        hint: selectedProvinceDestination ==
                                                null
                                            ? Text('Pilih Provinsi')
                                            : Text(selectedProvinceDestination
                                                .province),
                                        items: snapshot.data!
                                            .map<DropdownMenuItem<Province>>(
                                                (Province value) {
                                          return DropdownMenuItem(
                                              value: value,
                                              child: Text(
                                                  value.province.toString()));
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedProvinceDestination =
                                                newValue;
                                            cityDataDestination = getCities(
                                                selectedProvinceDestination
                                                    .provinceId);
                                          });
                                        });
                                  } else if (snapshot.hasError) {
                                    return Text("Tidak ada data");
                                  }
                                  return UiLoading.loadingSmall();
                                }),
                          ),
                          Flexible(
                            flex: 1,
                            child: FutureBuilder<List<City>>(
                                future: cityDataDestination,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return UiLoading.loadingSmall();
                                  }

                                  if (snapshot.hasData) {
                                    return DropdownButton(
                                        isExpanded: true,
                                        value: selectedCityDestination,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 30,
                                        elevation: 4,
                                        style: TextStyle(color: Colors.black),
                                        hint: selectedCityDestination == null
                                            ? Text('Pilih kota')
                                            : Text(selectedCityDestination
                                                .cityName),
                                        items: snapshot.data!
                                            .map<DropdownMenuItem<City>>(
                                                (City value) {
                                          return DropdownMenuItem(
                                              value: value,
                                              child: Text(
                                                  value.cityName.toString()));
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedCityDestination = newValue;
                                            cityIdDestination =
                                                selectedCityDestination.cityId;
                                          });
                                        });
                                  } else if (snapshot.hasError) {
                                    return Text("Tidak ada data");
                                  }
                                  return DropdownButton(
                                      isExpanded: true,
                                      value: selectedCityDestination,
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 30,
                                      elevation: 4,
                                      style: TextStyle(color: Colors.black),
                                      items: [],
                                      onChanged: (value) {
                                        Null;
                                      },
                                      isDense: false,
                                      hint: Text("Pilih kota"),
                                      disabledHint: Text("Pilih kota"));
                                  // return UiLoading.loadingSmall();
                                }),
                          )
                        ],
                      ),

                      Spacer(
                        flex: 3,
                      ),
                      //button elevated
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              updatedCost = await getCosts(
                                  selectedCityOrigin.cityId,
                                  selectedCityDestination.cityId,
                                  beratBarang.text,
                                  selectedKurir);
                              setState(() {
                                isLoading = false;
                                isCek = true;
                              });
                            },
                            child: const Text("Cek Ongkir"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 5,
                child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: !isCek
                        ? const Align(
                            alignment: Alignment.center,
                            child: Text("Data tidak ditemukan"),
                          )
                        : ListView.builder(
                            itemCount: updatedCost.length,
                            itemBuilder: (context, index) {
                              return cardListCost(updatedCost[index]);
                            })),
              ),
            ],
          ),
          isLoading == true ? UiLoading.loadingBlock() : Container()
        ],
      ),
    );
  }
}
