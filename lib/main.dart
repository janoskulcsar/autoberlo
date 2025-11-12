import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(const AirportRentalApp());

class Car {
  final String name, type, plate, imageUrl, fuelType;
  final int year, seats;
  final double pricePerDay, rating;

  Car(
    this.name, {
    required this.type,
    required this.plate,
    required this.imageUrl,
    required this.year,
    required this.seats,
    required this.fuelType,
    required this.pricePerDay,
    required this.rating,
  });
}

class Booking {
  final Car car;
  final DateTimeRange range;
  final bool gps, seat;
  double extrasPrice;
  Booking(this.car, this.range, {this.gps = false, this.seat = false})
      : extrasPrice = (gps ? 7 : 0) + (seat ? 5 : 0);

  double get totalPrice =>
      ((car.pricePerDay + extrasPrice) * range.duration.inDays.ceil());
}

class AirportRentalApp extends StatelessWidget {
  const AirportRentalApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reptéri Autóbérlés',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade700),
      ),
      debugShowCheckedModeBanner: false,
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int pageIndex = 0;
  final cars = <Car>[
    Car(
      'Toyota Corolla',
      type: 'Sedan',
      plate: 'ABC-123',
      imageUrl: 'https://www.carpro.com/hs-fs/hubfs/car-review-blog/review_337261_1.jpg?width=1020&name=review_337261_1.jpg',
      year: 2021,
      seats: 5,
      fuelType: 'Benzin',
      pricePerDay: 40,
      rating: 4.6,
    ),
    Car(
      'Volkswagen Golf',
      type: 'Hatchback',
      plate: 'XYZ-456',
      imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/2021-volkswagen-golf-104-1575554252.jpg?crop=0.683xw:0.744xh;0.109xw,0.246xh&resize=640:*',
      year: 2020,
      seats: 5,
      fuelType: 'Dízel',
      pricePerDay: 44.5,
      rating: 4.2,
    ),
    Car(
      'Renault Clio',
      type: 'Hatchback',
      plate: 'REN-789',
      imageUrl: 'https://cdn.pixabay.com/photo/2022/01/26/17/08/car-6969349_1280.jpg',
      year: 2022,
      seats: 5,
      fuelType: 'Elektromos',
      pricePerDay: 52,
      rating: 4.9,
    ),
    Car(
      'Ford Focus',
      type: 'Sedan',
      plate: 'FORD-001',
      imageUrl: 'https://cdn.pixabay.com/photo/2020/05/13/15/24/ford-5167838_1280.jpg',
      year: 2022,
      seats: 5,
      fuelType: 'Benzin',
      pricePerDay: 38,
      rating: 4.1,
    ),
  ];
  final bookings = <Booking>[];
  final favoriteCars = <Car>[];

  void addBooking(Booking booking) {
    setState(() => bookings.add(booking));
  }

  void removeBooking(Booking booking) {
    setState(() => bookings.remove(booking));
  }

  void removeFavorite(Car car) {
    setState(() => favoriteCars.remove(car));
  }

  void toggleFavorite(Car car) {
    setState(() {
      if (favoriteCars.contains(car)) {
        favoriteCars.remove(car);
      } else {
        favoriteCars.add(car);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      CarListPage(
        cars: cars,
        onBook: addBooking,
        favorites: favoriteCars,
        onToggleFavorite: toggleFavorite,
      ),
      BookingsPage(bookings: bookings, onRemove: removeBooking),
      FavoritesPage(favorites: favoriteCars, onRemove: removeFavorite),
    ];
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: pages[pageIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: pageIndex,
        onDestinationSelected: (i) => setState(() => pageIndex = i),
        elevation: 5,
        backgroundColor: Colors.white.withOpacity(0.85),
        height: 66,
        shadowColor: Colors.black.withOpacity(0.06),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.directions_car, size: 28),
            label: 'Autók',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_available, size: 28),
            label: 'Foglalások',
          ),
          NavigationDestination(icon: Icon(Icons.star, size: 28), label: 'Kedvencek'),
        ],
      ),
    );
  }
}

class CarListPage extends StatefulWidget {
  final List<Car> cars;
  final List<Car> favorites;
  final Function(Booking) onBook;
  final Function(Car) onToggleFavorite;

  const CarListPage({
    super.key,
    required this.cars,
    required this.onBook,
    required this.favorites,
    required this.onToggleFavorite,
  });
  @override
  State<CarListPage> createState() => _CarListPageState();
}

class _CarListPageState extends State<CarListPage> {
  String search = '';
  String filterType = 'Összes';

  @override
  Widget build(BuildContext context) {
    var filtered = widget.cars
        .where(
          (c) =>
              (filterType == 'Összes' || c.type == filterType) &&
              c.name.toLowerCase().contains(search.toLowerCase()),
        )
        .toList();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
              gradient: LinearGradient(
                colors: [Colors.blue.shade700, Colors.indigo.shade200],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [BoxShadow(blurRadius: 18, color: Colors.blue.shade600.withOpacity(0.16), spreadRadius: 6)],
            ),
            padding: const EdgeInsets.fromLTRB(0, 34, 0, 28),
            child: Column(
              children: [
                Icon(Icons.airport_shuttle, color: Colors.white, size: 52),
                const SizedBox(height: 2),
                Text('Reptéri autóbérlés',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.indigo.shade400, blurRadius: 12)],
                    )),
                const SizedBox(height: 6),
                Text("Foglalj autót gyorsan, kényelmesen!",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.93),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  )),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 7),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(color: Colors.blueGrey.shade100, blurRadius: 7, offset: const Offset(0,2))],
                    ),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Keresés',
                        hintStyle: TextStyle(letterSpacing: 1),
                        prefixIcon: Icon(Icons.search, color: Colors.blueGrey, size: 23),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      ),
                      onChanged: (v) => setState(() => search = v),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: filterType,
                  borderRadius: BorderRadius.circular(12),
                  items: ['Összes', 'Sedan', 'Hatchback']
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (v) => setState(() => filterType = v ?? 'Összes'),
                  underline: Container(),
                ),
              ],
            ),
          ),
        ),
        filtered.isEmpty
            ? const SliverFillRemaining(
                child: Center(
                  child: Text('Nincs találat!', style: TextStyle(fontSize: 16)),
                ),
              )
            : SliverList.builder(
                itemCount: filtered.length + 1,
                itemBuilder: (ctx, idx) {
                  if (idx == filtered.length) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: Center(
                        child: Text(
                          "— Vége a listának —",
                          style: TextStyle(color: Colors.grey.shade400, letterSpacing: 1),
                        ),
                      ),
                    );
                  }
                  final car = filtered[idx];
                  final isFavorite = widget.favorites.contains(car);
                  return Card(
                    elevation: 7,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: Colors.white.withOpacity(0.98),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                        builder: (c) => BookingStepSheet(
                          car,
                          onBook: (booking) {
                            widget.onBook(booking);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Foglalás rögzítve: ${car.name}'),
                                duration: const Duration(seconds: 2),
                                backgroundColor: Colors.indigo,
                              ),
                            );
                          },
                        ),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)
                                ),
                                child: Image.network(
                                  car.imageUrl,
                                  height: 138,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (cx, e, st) => Container(
                                    color: Colors.blue.shade100,
                                    height: 138,
                                    child: const Icon(
                                      Icons.directions_car_filled,
                                      size: 70,
                                      color: Colors.indigo,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(car.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    const SizedBox(height: 1),
                                    Row(
                                      children: [
                                        Icon(Icons.star, color: Colors.yellow[700], size: 16),
                                        const SizedBox(width: 2),
                                        Text('${car.rating}', style: const TextStyle(fontSize: 13)),
                                        const SizedBox(width: 10),
                                        Icon(Icons.local_gas_station, size: 15, color: Colors.deepPurple.shade300),
                                        const SizedBox(width: 2),
                                        Text(car.fuelType, style: const TextStyle(fontSize: 13)),
                                        const SizedBox(width: 9),
                                        Icon(Icons.event_seat, size: 15, color: Colors.blueGrey.shade300),
                                        Text('  ${car.seats} fő', style: const TextStyle(fontSize: 13)),
                                      ],
                                    ),
                                    const SizedBox(height: 1),
                                    Text('${car.pricePerDay.toStringAsFixed(0)} €/nap', style: const TextStyle(fontSize: 13, color: Colors.indigo, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            right: 12,
                            top: 12,
                            child: Material(
                              color: Colors.white54,
                              borderRadius: BorderRadius.circular(50),
                              child: IconButton(
                                icon: Icon(isFavorite ? Icons.star : Icons.star_border, color: Colors.orange.shade500),
                                onPressed: () => widget.onToggleFavorite(car),
                                tooltip: isFavorite
                                    ? 'Kedvencekből törlés'
                                    : 'Kedvencekbe',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }
}

class BookingStepSheet extends StatefulWidget {
  final Car car;
  final Function(Booking) onBook;
  const BookingStepSheet(this.car, {super.key, required this.onBook});

  @override
  State<BookingStepSheet> createState() => _BookingStepSheetState();
}

class _BookingStepSheetState extends State<BookingStepSheet> {
  bool bookingSent = false;
  bool extraGPS = false;
  bool extraSeat = false;
  DateTimeRange? rentRange;

  @override
  Widget build(BuildContext context) {
    final car = widget.car;
    final gpsPrice = extraGPS ? 7 : 0;
    final seatPrice = extraSeat ? 5 : 0;
    final totalPerDay = car.pricePerDay + gpsPrice + seatPrice;
    final days = rentRange != null ? rentRange!.duration.inDays.ceil() : 1;
    final totalSum = rentRange != null ? totalPerDay * days : totalPerDay;

    if (bookingSent) {
      return SizedBox(
        height: 400,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.done_all, size: 60, color: Colors.green),
              const SizedBox(height: 12),
              Text(
                'Foglalás sikeres!',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 21,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${car.name} - ${car.plate}',
                style: const TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 12,
        top: 16,
        left: 16,
        right: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                width: 68,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              car.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(height: 5),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                car.imageUrl,
                height: 110,
                width: 210,
                fit: BoxFit.cover,
                errorBuilder: (c, e, st) => Container(
                  color: Colors.blue.shade100,
                  height: 110,
                  width: 210,
                  child: const Icon(
                    Icons.directions_car_filled,
                    size: 54,
                    color: Colors.indigo,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.blueGrey.shade300,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text('${car.type} • ${car.year} • ${car.fuelType}'),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Időpont:',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.date_range),
                  label: Text(
                    rentRange == null
                        ? 'Válassz dátumot'
                        : '${DateFormat('yyyy.MM.dd').format(rentRange!.start)} - ${DateFormat('yyyy.MM.dd').format(rentRange!.end)}',
                  ),
                  onPressed: () async {
                    var now = DateTime.now();
                    DateTimeRange? picker = await showDateRangePicker(
                      context: context,
                      firstDate: now,
                      lastDate: DateTime(now.year, now.month + 2, now.day),
                      initialDateRange:
                          rentRange ??
                          DateTimeRange(
                            start: now,
                            end: now.add(const Duration(days: 2)),
                          ),
                    );
                    if (picker != null) setState(() => rentRange = picker);
                  },
                ),
              ],
            ),
            SwitchListTile(
              value: extraGPS,
              onChanged: (v) => setState(() => extraGPS = v),
              title: const Text('GPS extra'),
              subtitle: const Text('GPS navigációs modul (+7 €/nap)'),
              secondary: const Icon(Icons.gps_fixed),
            ),
            SwitchListTile(
              value: extraSeat,
              onChanged: (v) => setState(() => extraSeat = v),
              title: const Text('Gyerekülés'),
              subtitle: const Text('Utazás gyerekkel (+5 €/nap)'),
              secondary: const Icon(Icons.child_friendly),
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(text: 'Ár: '),
                  TextSpan(
                    text: '${car.pricePerDay.toStringAsFixed(0)} €/nap',
                    style: const TextStyle(color: Colors.indigo),
                  ),
                  if (gpsPrice > 0) TextSpan(text: ' + $gpsPrice €/GPS'),
                  if (seatPrice > 0) TextSpan(text: ' + $seatPrice €/ülés'),
                  TextSpan(text: '  x $days nap =  '),
                  TextSpan(
                    text: '${totalSum.toStringAsFixed(0)} €',
                    style: const TextStyle(color: Colors.deepPurple),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.check_circle),
              label: const Text('Foglalás elküldése'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: rentRange != null
                  ? () {
                      widget.onBook(
                        Booking(
                          car,
                          rentRange!,
                          gps: extraGPS,
                          seat: extraSeat,
                        ),
                      );
                      setState(() => bookingSent = true);
                    }
                  : null,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class BookingsPage extends StatefulWidget {
  final List<Booking> bookings;
  final void Function(Booking) onRemove;
  const BookingsPage({super.key, required this.bookings, required this.onRemove});
  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  @override
  Widget build(BuildContext context) {
    if (widget.bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_available, size: 54, color: Colors.indigo),
            const SizedBox(height: 8),
            const Text(
              'Nincs foglalás!',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Foglalj autót a főoldalon!',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: widget.bookings.length,
      itemBuilder: (ctx, i) {
        final b = widget.bookings[i];
        return Card(
          color: Colors.indigo.shade50,
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: ListTile(
            leading: Image.network(
              b.car.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (c, e, st) => Container(
                width: 60,
                height: 60,
                color: Colors.grey[200],
                child: const Icon(Icons.directions_car_filled),
              ),
            ),
            title: Text(
              '${b.car.name} (${b.car.plate})',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${DateFormat('yyyy.MM.dd').format(b.range.start)} - ${DateFormat('yyyy.MM.dd').format(b.range.end)}'
              '\nExtra: ${b.gps ? "GPS " : ""}${b.seat ? "Gyerekülés" : ""}'
              '\nVégösszeg: ${b.totalPrice.toStringAsFixed(0)} €',
              style: const TextStyle(fontSize: 14),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.gps_fixed, color: b.gps ? Colors.green : Colors.grey, size: 22),
                Icon(Icons.child_friendly, color: b.seat ? Colors.orange : Colors.grey, size: 22),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: "Foglalás törlése",
                  onPressed: () {
                    setState(() {
                      widget.onRemove(b);
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FavoritesPage extends StatefulWidget {
  final List<Car> favorites;
  final Function(Car)? onRemove;
  const FavoritesPage({super.key, required this.favorites, this.onRemove});
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    if (widget.favorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, size: 48, color: Colors.amber),
            const SizedBox(height: 8),
            const Text(
              'Még nincs kedvenc autód!',
              style: TextStyle(fontSize: 19),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      itemCount: widget.favorites.length,
      itemBuilder: (ctx, i) {
        final car = widget.favorites[i];
        return Card(
          color: Colors.amber[50],
          margin: const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
          child: ListTile(
            leading: Image.network(
              car.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (c, e, st) => Container(
                width: 60,
                height: 60,
                color: Colors.grey[200],
                child: const Icon(Icons.directions_car_filled),
              ),
            ),
            title: Text(car.name),
            subtitle: Text('${car.type}, ${car.plate}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.indigo),
              onPressed: () {
                setState(() {
                  widget.onRemove?.call(car);
                });
              },
              tooltip: 'Eltávolítás',
            ),
          ),
        );
      },
    );
  }
}
