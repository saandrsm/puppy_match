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
        price: 120,
      ),
      Product(
        breed: Breed.accessories,
        id: 1,
        name: 'Thor',
        price: 58,
      ),
      Product(
        breed: Breed.accessories,
        id: 2,
        name: 'Max',
        price: 35,
      ),
      Product(
        breed: Breed.accessories,
        id: 3,
        name: 'Simba',
        price: 98,
      ),
      Product(
        breed: Breed.accessories,
        id: 4,
        name: 'Leo',
        price: 34,
      ),
      Product(
        breed: Breed.accessories,
        id: 5,
        name: 'Rocky',
        price: 12,
      ),
      Product(
        breed: Breed.accessories,
        id: 6,
        name: 'Nala',
        price: 16,
      ),
      Product(
        breed: Breed.accessories,
        id: 7,
        name: 'Kyra',
        price: 40,
      ),
      Product(
        breed: Breed.accessories,
        id: 8,
        name: 'Toby',
        price: 198,
      ),
      Product(
        breed: Breed.home,
        id: 9,
        name: 'Zeus',
        price: 58,
      ),
      Product(
        breed: Breed.home,
        id: 10,
        name: 'Lia',
        price: 18,
      ),
      Product(
        breed: Breed.home,
        id: 11,
        name: 'Connor',
        price: 28,
      ),
      Product(
        breed: Breed.home,
        id: 12,
        name: 'Duc',
        price: 34,
      ),
      Product(
        breed: Breed.home,
        id: 13,
        name: 'Maya',
        price: 18,
      ),
      Product(
        breed: Breed.home,
        id: 14,
        name: 'Kira',
        price: 27,
      ),
      Product(
        breed: Breed.home,
        id: 15,
        name: 'Beni',
        price: 16,
      ),
      Product(
        breed: Breed.home,
        id: 16,
        name: 'Yako',
        price: 16,
      ),
      Product(
        breed: Breed.home,
        id: 17,
        name: 'Ron',
        price: 175,
      ),
      Product(
        breed: Breed.home,
        id: 18,
        name: 'Roma',
        price: 129,
      ),
      Product(
        breed: Breed.clothing,
        id: 19,
        name: 'Zoe',
        price: 48,
      ),
      Product(
        breed: Breed.clothing,
        id: 20,
        name: 'Dama',
        price: 45,
      ),
      Product(
        breed: Breed.clothing,
        id: 21,
        name: 'Iris',
        price: 38,
      ),
      Product(
        breed: Breed.clothing,
        id: 22,
        name: 'Toby',
        price: 70,
      ),
      Product(
        breed: Breed.clothing,
        id: 23,
        name: 'Tango',
        price: 70,
      ),
      Product(
        breed: Breed.clothing,
        id: 24,
        name: 'Oreo',
        price: 60,
      ),
      Product(
        breed: Breed.clothing,
        id: 25,
        name: 'Pancho',
        price: 178,
      ),
      Product(
        breed: Breed.clothing,
        id: 26,
        name: 'Shira',
        price: 74,
      ),
      Product(
        breed: Breed.clothing,
        id: 27,
        name: 'Aslan',
        price: 38,
      ),
      Product(
        breed: Breed.clothing,
        id: 28,
        name: 'Gus',
        price: 48,
      ),
      Product(
        breed: Breed.clothing,
        id: 29,
        name: 'Tana',
        price: 98,
      ),
      Product(
        breed: Breed.clothing,
        id: 30,
        name: 'Gala',
        price: 68,
      ),
      Product(
        breed: Breed.clothing,
        id: 31,
        name: 'Cooper',
        price: 38,
      ),
      Product(
        breed: Breed.clothing,
        id: 32,
        name: 'Ares',
        price: 58,
      ),
      Product(
        breed: Breed.clothing,
        id: 33,
        name: 'Rocco',
        price: 42,
      ),
      Product(
        breed: Breed.clothing,
        id: 34,
        name: 'Charlie',
        price: 27,
      ),
      Product(
        breed: Breed.clothing,
        id: 35,
        name: 'Chloe',
        price: 24,
      ),
      Product(
        breed: Breed.clothing,
        id: 36,
        name: 'Mika',
        price: 58,
      ),
      Product(
        breed: Breed.clothing,
        id: 37,
        name: 'Brownie',
        price: 58,
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
