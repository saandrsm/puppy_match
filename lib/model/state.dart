import 'package:image_picker/image_picker.dart';

abstract class GlobalState {
  static PetState? petState;
}

class PetState {
  List<XFile> photos;
  PetState(this.photos);
}