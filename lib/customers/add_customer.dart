import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../data/customer_store.dart';

class AddCustomerScreen extends StatefulWidget {
  static const routeName = '/add-customer';
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  final Map<String, TextEditingController> _measureCtrls = {
    'Chest': TextEditingController(),
    'Waist': TextEditingController(),
    'Hip': TextEditingController(),
    'Shoulder': TextEditingController(),
    'Sleeve Length': TextEditingController(),
    'Neck': TextEditingController(),
    'Blouse Length': TextEditingController(),
  };
  final Set<String> _styles = {};
  String? _photoPath;

  final _picker = ImagePicker();

  final List<String> _styleOptions = const [
    'Anarkali',
    'Lehenga',
    'Saree Blouse',
    'Kurti',
    'Gown',
    'Salwar',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    for (final c in _measureCtrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final xfile = await _picker.pickImage(source: source, maxWidth: 1024, imageQuality: 85);
    if (xfile != null) {
      setState(() => _photoPath = xfile.path);
    }
  }

  void _autofillExisting(String phone) {
    final existing = CustomerStore().findByPhone(phone);
    if (existing != null) {
      _nameController.text = existing.name;
      _photoPath = existing.photoPath;
      _styles
        ..clear()
        ..addAll(existing.styles);
      _measureCtrls['Chest']!.text = (existing.chest ?? '').toString();
      _measureCtrls['Waist']!.text = (existing.waist ?? '').toString();
      _measureCtrls['Hip']!.text = (existing.hip ?? '').toString();
      _measureCtrls['Shoulder']!.text = (existing.shoulder ?? '').toString();
      _measureCtrls['Sleeve Length']!.text = (existing.sleeveLength ?? '').toString();
      _measureCtrls['Neck']!.text = (existing.neck ?? '').toString();
      _measureCtrls['Blouse Length']!.text = (existing.blouseLength ?? '').toString();
      _notesController.text = existing.notes ?? '';
      setState(() {});
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    double? parse(String k) {
      return double.tryParse(_measureCtrls[k]!.text.trim());
    }
    final c = Customer(
      id: id,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      photoPath: _photoPath,
      chest: parse('Chest'),
      waist: parse('Waist'),
      hip: parse('Hip'),
      shoulder: parse('Shoulder'),
      sleeveLength: parse('Sleeve Length'),
      neck: parse('Neck'),
      blouseLength: parse('Blouse Length'),
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      styles: _styles.toList(),
    );
    CustomerStore().add(c);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const indigo = Color(0xFF1A237E);
    const gold = Color(0xFFFFD700);
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Customer'), backgroundColor: indigo, elevation: 0),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.black12,
                    backgroundImage: _photoPath != null ? FileImage(File(_photoPath!)) : null,
                    child: _photoPath == null ? const Icon(Icons.person, color: Colors.white70) : null,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.camera),
                        icon: const Icon(Icons.photo_camera),
                        label: const Text('Camera'),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Gallery'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Name', style: TextStyle(fontWeight: FontWeight.w700, color: indigo)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Customer name (తెలుగు / English)'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter name' : null,
              ),
              const SizedBox(height: 12),
              const Text('Phone', style: TextStyle(fontWeight: FontWeight.w700, color: indigo)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d +-]'))],
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: '+91 98765 43210'),
                onChanged: _autofillExisting,
                validator: (v) => (v == null || v.trim().length < 8) ? 'Enter phone' : null,
              ),
              const SizedBox(height: 16),
              const Text('Measurements (cm)', style: TextStyle(fontWeight: FontWeight.w700, color: indigo)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _measureCtrls.entries.map((e) {
                  return SizedBox(
                    width: 160,
                    child: TextFormField(
                      controller: e.value,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                      decoration: InputDecoration(
                        labelText: e.key,
                        suffixText: 'cm',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text('Favorite Styles', style: TextStyle(fontWeight: FontWeight.w700, color: indigo)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _styleOptions.map((s) {
                  final selected = _styles.contains(s);
                  return FilterChip(
                    label: Text(s),
                    selected: selected,
                    onSelected: (v) {
                      setState(() {
                        if (v) {
                          _styles.add(s);
                        } else {
                          _styles.remove(s);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text('Notes', style: TextStyle(fontWeight: FontWeight.w700, color: indigo)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Special instructions'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gold,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _save,
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
