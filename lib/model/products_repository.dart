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
  static List<Product> loadProducts(Category category) {
    const allProducts = <Product>[
      Product(
        category: Category.accessories,
        id: 0,
        isFeatured: true,
        name: 'Coco',
        price: 120,
      ),
      Product(
        category: Category.accessories,
        id: 1,
        isFeatured: true,
        name: 'Thor',
        price: 58,
      ),
      Product(
        category: Category.accessories,
        id: 2,
        isFeatured: false,
        name: 'Max',
        price: 35,
      ),
      Product(
        category: Category.accessories,
        id: 3,
        isFeatured: true,
        name: 'Simba',
        price: 98,
      ),
      Product(
        category: Category.accessories,
        id: 4,
        isFeatured: false,
        name: 'Leo',
        price: 34,
      ),
      Product(
        category: Category.accessories,
        id: 5,
        isFeatured: false,
        name: 'Rocky',
        price: 12,
      ),
      Product(
        category: Category.accessories,
        id: 6,
        isFeatured: false,
        name: 'Nala',
        price: 16,
      ),
      Product(
        category: Category.accessories,
        id: 7,
        isFeatured: true,
        name: 'Kyra',
        price: 40,
      ),
      Product(
        category: Category.accessories,
        id: 8,
        isFeatured: true,
        name: 'Toby',
        price: 198,
      ),
      Product(
        category: Category.home,
        id: 9,
        isFeatured: true,
        name: 'Zeus',
        price: 58,
      ),
      Product(
        category: Category.home,
        id: 10,
        isFeatured: false,
        name: 'Lia',
        price: 18,
      ),
      Product(
        category: Category.home,
        id: 11,
        isFeatured: false,
        name: 'Connor',
        price: 28,
      ),
      Product(
        category: Category.home,
        id: 12,
        isFeatured: false,
        name: 'Duc',
        price: 34,
      ),
      Product(
        category: Category.home,
        id: 13,
        isFeatured: true,
        name: 'Maya',
        price: 18,
      ),
      Product(
        category: Category.home,
        id: 14,
        isFeatured: true,
        name: 'Tika',
        price: 27,
      ),
      Product(
        category: Category.home,
        id: 15,
        isFeatured: true,
        name: 'Berni',
        price: 16,
      ),
      Product(
        category: Category.home,
        id: 16,
        isFeatured: true,
        name: 'Yako',
        price: 16,
      ),
      Product(
        category: Category.home,
        id: 17,
        isFeatured: false,
        name: 'Ron',
        price: 175,
      ),
      Product(
        category: Category.home,
        id: 18,
        isFeatured: true,
        name: 'Roma',
        price: 129,
      ),
      Product(
        category: Category.clothing,
        id: 19,
        isFeatured: false,
        name: 'Zoe',
        price: 48,
      ),
      Product(
        category: Category.clothing,
        id: 20,
        isFeatured: false,
        name: 'Dama',
        price: 45,
      ),
      Product(
        category: Category.clothing,
        id: 21,
        isFeatured: false,
        name: 'Iris',
        price: 38,
      ),
      Product(
        category: Category.clothing,
        id: 22,
        isFeatured: false,
        name: 'Toby',
        price: 70,
      ),
      Product(
        category: Category.clothing,
        id: 23,
        isFeatured: false,
        name: 'Tango',
        price: 70,
      ),
      Product(
        category: Category.clothing,
        id: 24,
        isFeatured: true,
        name: 'Oreo',
        price: 60,
      ),
      Product(
        category: Category.clothing,
        id: 25,
        isFeatured: false,
        name: 'Pancho',
        price: 178,
      ),
      Product(
        category: Category.clothing,
        id: 26,
        isFeatured: false,
        name: 'Shira',
        price: 74,
      ),
      Product(
        category: Category.clothing,
        id: 27,
        isFeatured: true,
        name: 'Aslan',
        price: 38,
      ),
      Product(
        category: Category.clothing,
        id: 28,
        isFeatured: true,
        name: 'Gus',
        price: 48,
      ),
      Product(
        category: Category.clothing,
        id: 29,
        isFeatured: true,
        name: 'Tana',
        price: 98,
      ),
      Product(
        category: Category.clothing,
        id: 30,
        isFeatured: true,
        name: 'Gala',
        price: 68,
      ),
      Product(
        category: Category.clothing,
        id: 31,
        isFeatured: false,
        name: 'Cooper',
        price: 38,
      ),
      Product(
        category: Category.clothing,
        id: 32,
        isFeatured: false,
        name: 'Ares',
        price: 58,
      ),
      Product(
        category: Category.clothing,
        id: 33,
        isFeatured: true,
        name: 'Rocco',
        price: 42,
      ),
      Product(
        category: Category.clothing,
        id: 34,
        isFeatured: false,
        name: 'Charlie',
        price: 27,
      ),
      Product(
        category: Category.clothing,
        id: 35,
        isFeatured: false,
        name: 'Chloe',
        price: 24,
      ),
      Product(
        category: Category.clothing,
        id: 36,
        isFeatured: false,
        name: 'Mika',
        price: 58,
      ),
      Product(
        category: Category.clothing,
        id: 37,
        isFeatured: true,
        name: 'Brownie',
        price: 58,
      ),
    ];
    if (category == Category.all) {
      return allProducts;
    } else {
      return allProducts.where((Product p) {
        return p.category == category;
      }).toList();
    }
  }
}
