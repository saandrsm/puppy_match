// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'product.dart';

class ProductsRepository {
  static List<Product> loadProducts(Breed breed) {
    const allProducts = <Product>[
      Product(
        breed: Breed.accessories,
        id: 0,
        name: 'Coco',
        age: '1 año',
      ),
      Product(
        breed: Breed.accessories,
        id: 1,
        name: 'Thor',
        age: '5 años',
      ),
      Product(
        breed: Breed.accessories,
        id: 2,
        name: 'Max',
        age: '3 años',
      ),
      Product(
        breed: Breed.accessories,
        id: 3,
        name: 'Simba',
        age: '9 años',
      ),
      Product(
        breed: Breed.accessories,
        id: 4,
        name: 'Leo',
        age: '4 años',
      ),
      Product(
        breed: Breed.accessories,
        id: 5,
        name: 'Rocky',
        age: '1 año',
      ),
      Product(
        breed: Breed.accessories,
        id: 6,
        name: 'Nala',
        age: '6 años',
      ),
      Product(
        breed: Breed.accessories,
        id: 7,
        name: 'Kyra',
        age: '4 años',
      ),
      Product(
        breed: Breed.accessories,
        id: 8,
        name: 'Toby',
        age: '8 años',
      ),
      Product(
        breed: Breed.home,
        id: 9,
        name: 'Zeus',
        age: '5 años',
      ),
      Product(
        breed: Breed.home,
        id: 10,
        name: 'Lia',
        age: '1 año',
      ),
      Product(
        breed: Breed.home,
        id: 11,
        name: 'Connor',
        age: '2 años',
      ),
      Product(
        breed: Breed.home,
        id: 12,
        name: 'Duc',
        age: '3 años',
      ),
      Product(
        breed: Breed.home,
        id: 13,
        name: 'Maya',
        age: '1 año',
      ),
      Product(
        breed: Breed.home,
        id: 14,
        name: 'Kira',
        age: '2 años',
      ),
      Product(
        breed: Breed.home,
        id: 15,
        name: 'Beni',
        age: '6 años',
      ),
      Product(
        breed: Breed.home,
        id: 16,
        name: 'Yako',
        age: '6 años',
      ),
      Product(
        breed: Breed.home,
        id: 17,
        name: 'Ron',
        age: '5 años',
      ),
      Product(
        breed: Breed.home,
        id: 18,
        name: 'Roma',
        age: '2 años',
      ),
      Product(
        breed: Breed.clothing,
        id: 19,
        name: 'Zoe',
        age: '4 años',
      ),
      Product(
        breed: Breed.clothing,
        id: 20,
        name: 'Dama',
        age: '4 años',
      ),
      Product(
        breed: Breed.clothing,
        id: 21,
        name: 'Iris',
        age: '3 años',
      ),
      Product(
        breed: Breed.clothing,
        id: 22,
        name: 'Toby',
        age: '7 años',
      ),
      Product(
        breed: Breed.clothing,
        id: 23,
        name: 'Tango',
        age: '7 años',
      ),
      Product(
        breed: Breed.clothing,
        id: 24,
        name: 'Oreo',
        age: '6 años',
      ),
      Product(
        breed: Breed.clothing,
        id: 25,
        name: 'Pancho',
        age: '7 años',
      ),
      Product(
        breed: Breed.clothing,
        id: 26,
        name: 'Shira',
        age: '4 años',
      ),
      Product(
        breed: Breed.clothing,
        id: 27,
        name: 'Aslan',
        age: '3 años',
      ),
      Product(
        breed: Breed.clothing,
        id: 28,
        name: 'Gus',
        age: '4 años',
      ),
      Product(
        breed: Breed.clothing,
        id: 29,
        name: 'Tana',
        age: '9 años',
      ),
      Product(
        breed: Breed.clothing,
        id: 30,
        name: 'Gala',
        age: '6 años',
      ),
      Product(
        breed: Breed.clothing,
        id: 31,
        name: 'Cooper',
        age: '3 años',
      ),
      Product(
        breed: Breed.clothing,
        id: 32,
        name: 'Ares',
        age: '5 años',
      ),
      Product(
        breed: Breed.clothing,
        id: 33,
        name: 'Rocco',
        age: '4 años',
      ),
      Product(
        breed: Breed.clothing,
        id: 34,
        name: 'Charlie',
        age: '3 años',
      ),
      Product(
        breed: Breed.clothing,
        id: 35,
        name: 'Chloe',
        age: '2 años',
      ),
      Product(
        breed: Breed.clothing,
        id: 36,
        name: 'Mika',
        age: '5 años',
      ),
      Product(
        breed: Breed.clothing,
        id: 37,
        name: 'Brownie',
        age: '5 años',
      ),
    ];
    if (breed == Breed.all) {
      return allProducts;
    } else {
      return allProducts.where((Product p) {
        return p.breed == breed;
      }).toList();
    }
  }
}
