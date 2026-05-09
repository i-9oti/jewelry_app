class ProductData {
  static const List<Map<String, dynamic>> products = [
    // خواتم (Rings) - 5 files
    {"name": "خاتم ذهب عيار 21 ملكي", "category": "خواتم", "karat": "21", "weight": 4.5, "stoneWeight": 0.5, "rating": 4.9, "image": "assets/images/rings/12.webp"},
    {"name": "خاتم ذهب ناعم عيار 18", "category": "خواتم", "karat": "18", "weight": 3.1, "stoneWeight": 0.0, "rating": 4.6, "image": "assets/images/rings/13.webp"},
    {"name": "خاتم ذهب كلاسيكي عيار 21", "category": "خواتم", "karat": "21", "weight": 3.8, "stoneWeight": 0.2, "rating": 4.8, "image": "assets/images/rings/14.webp"},
    {"name": "خاتم ذهب فص كبير", "category": "خواتم", "karat": "21", "weight": 5.5, "stoneWeight": 1.2, "rating": 4.7, "image": "assets/images/rings/15.jpg"},
    {"name": "خاتم زفاف ذهب عيار 24", "category": "خواتم", "karat": "24", "weight": 6.2, "stoneWeight": 0.0, "rating": 5.0, "image": "assets/images/rings/16.webp"},

    // أساور (Bracelets) - 4 files
    {"name": "اسوارة ذهب عيار 18 كلاسيك", "category": "اساور", "karat": "18", "weight": 2.8, "stoneWeight": 0.0, "rating": 4.7, "image": "assets/images/bracelets/8.webp"},
    {"name": "اسوارة لؤلؤ وذهب عيار 18", "category": "اساور", "karat": "18", "weight": 3.0, "stoneWeight": 0.5, "rating": 4.6, "image": "assets/images/bracelets/9.jpg"},
    {"name": "اسوارة ذهب عيار 21 مزخرفة", "category": "اساور", "karat": "21", "weight": 6.2, "stoneWeight": 0.0, "rating": 4.8, "image": "assets/images/bracelets/10.webp"},
    {"name": "اسوارة ذهب عيار 21 عريضة", "category": "اساور", "karat": "21", "weight": 7.5, "stoneWeight": 0.0, "rating": 4.9, "image": "assets/images/bracelets/11.webp"},

    // أقراط (Earrings) - 4 files
    {"name": "حلق ذهب عيار 21 فاخر", "category": "اقراط", "karat": "21", "weight": 1.1, "stoneWeight": 0.4, "rating": 4.8, "image": "assets/images/earrings/17.webp"},
    {"name": "حلق ذهب عيار 18 ناعم", "category": "اقراط", "karat": "18", "weight": 1.2, "stoneWeight": 0.0, "rating": 4.6, "image": "assets/images/earrings/18.webp"},
    {"name": "حلق ذهب عيار 21 طويل", "category": "اقراط", "karat": "21", "weight": 2.5, "stoneWeight": 0.0, "rating": 4.7, "image": "assets/images/earrings/19.webp"},
    {"name": "حلق ذهب عيار 18 دائري", "category": "اقراط", "karat": "18", "weight": 2.0, "stoneWeight": 0.0, "rating": 4.5, "image": "assets/images/earrings/20.webp"},

    // خلخال (Anklets) - 6 files
    {"name": "خلخال ذهب عيار 18 ناعم", "category": "خلخال", "karat": "18", "weight": 1.5, "stoneWeight": 0.0, "rating": 4.7, "image": "assets/images/anklets/33.webp"},
    {"name": "خلخال ذهب عيار 21 كلاسيكي", "category": "خلخال", "karat": "21", "weight": 2.0, "stoneWeight": 0.0, "rating": 4.8, "image": "assets/images/anklets/34.webp"},
    {"name": "خلخال ذهب عيار 18 مزخرف", "category": "خلخال", "karat": "18", "weight": 1.8, "stoneWeight": 0.0, "rating": 4.6, "image": "assets/images/anklets/35.webp"},
    {"name": "خلخال ذهب عيار 21 هادئ", "category": "خلخال", "karat": "21", "weight": 2.3, "stoneWeight": 0.0, "rating": 4.5, "image": "assets/images/anklets/36.webp"},
    {"name": "خلخال ذهب عيار 18 بسيط", "category": "خلخال", "karat": "18", "weight": 1.4, "stoneWeight": 0.0, "rating": 4.7, "image": "assets/images/anklets/37.webp"},
    {"name": "خلخال ذهب عيار 21 فاخر", "category": "خلخال", "karat": "21", "weight": 2.6, "stoneWeight": 0.0, "rating": 4.9, "image": "assets/images/anklets/38.webp"},

    // طقم كامل (Full Sets) - 6 files
    {"name": "طقم ذهب عيار 21 ملكي", "category": "طقم كامل", "karat": "21", "weight": 22.5, "stoneWeight": 2.5, "rating": 5.0, "image": "assets/images/sets/21.webp"},
    {"name": "طقم ذهب عيار 18 ناعم", "category": "طقم كامل", "karat": "18", "weight": 12.0, "stoneWeight": 0.0, "rating": 4.8, "image": "assets/images/sets/22.webp"},
    {"name": "طقم ذهب عيار 24 للعروس", "category": "طقم كامل", "karat": "24", "weight": 35.0, "stoneWeight": 5.0, "rating": 5.0, "image": "assets/images/sets/23.webp"},
    {"name": "طقم ذهب عيار 21 شرقي", "category": "طقم كامل", "karat": "21", "weight": 28.0, "stoneWeight": 1.5, "rating": 4.9, "image": "assets/images/sets/24.webp"},
    {"name": "طقم ذهب عيار 21 مزخرف", "category": "طقم كامل", "karat": "21", "weight": 25.0, "stoneWeight": 0.5, "rating": 4.7, "image": "assets/images/sets/25.webp"},
    {"name": "طقم ذهب عيار 18 عصري", "category": "طقم كامل", "karat": "18", "weight": 14.5, "stoneWeight": 0.0, "rating": 4.8, "image": "assets/images/sets/26.webp"},

    // غوايش (Bangles) - 6 files
    {"name": "غوايش ذهب عيار 21 هندي", "category": "غوايش", "karat": "21", "weight": 12.0, "stoneWeight": 0.0, "rating": 4.9, "image": "assets/images/bangles/2.webp"},
    {"name": "غوايش ذهب عيار 18 عريضة", "category": "غوايش", "karat": "18", "weight": 10.5, "stoneWeight": 0.0, "rating": 4.7, "image": "assets/images/bangles/3.jpg"},
    {"name": "غوايش ذهب عيار 21 كلاسيك", "category": "غوايش", "karat": "21", "weight": 14.2, "stoneWeight": 0.0, "rating": 4.8, "image": "assets/images/bangles/4.jpg"},
    {"name": "غوايش ذهب عيار 21 مزخرفة", "category": "غوايش", "karat": "21", "weight": 11.0, "stoneWeight": 0.0, "rating": 4.6, "image": "assets/images/bangles/5.webp"},
    {"name": "غوايش ذهب عيار 24 فاخرة", "category": "غوايش", "karat": "24", "weight": 16.5, "stoneWeight": 0.0, "rating": 5.0, "image": "assets/images/bangles/6.webp"},
    {"name": "غوايش ذهب عيار 18 ناعمة", "category": "غوايش", "karat": "18", "weight": 8.5, "stoneWeight": 0.0, "rating": 4.5, "image": "assets/images/bangles/7.webp"},

    // كفوف (Hand Pieces) - 6 files
    {"name": "كف ذهب عيار 21 ملكي", "category": "كفوف", "karat": "21", "weight": 18.2, "stoneWeight": 0.5, "rating": 4.9, "image": "assets/images/gloves/27.webp"},
    {"name": "كف ذهب عيار 18 ناعم", "category": "كفوف", "karat": "18", "weight": 10.5, "stoneWeight": 0.0, "rating": 4.7, "image": "assets/images/gloves/28.webp"},
    {"name": "كف ذهب عيار 21 بسيط", "category": "كفوف", "karat": "21", "weight": 14.0, "stoneWeight": 0.0, "rating": 4.8, "image": "assets/images/gloves/29.webp"},
    {"name": "كف ذهب عيار 21 مزخرف", "category": "كفوف", "karat": "21", "weight": 16.5, "stoneWeight": 0.0, "rating": 4.6, "image": "assets/images/gloves/30.webp"},
    {"name": "كف ذهب عيار 18 عصري", "category": "كفوف", "karat": "18", "weight": 11.2, "stoneWeight": 0.0, "rating": 4.5, "image": "assets/images/gloves/31.webp"},
    {"name": "كف ذهب عيار 21 هادئ", "category": "كفوف", "karat": "21", "weight": 13.5, "stoneWeight": 0.0, "rating": 4.7, "image": "assets/images/gloves/32.webp"},

    // سلاسل (Necklaces) - 11 files
    {"name": "عقد ذهب عيار 21 فاخر", "category": "سلاسل", "karat": "21", "weight": 12.0, "stoneWeight": 0.0, "rating": 4.9, "image": "assets/images/necklaces/bd424935-658d-4665-b47f-b783be3beb41-1000x1000-wYoawOxrbvxt64muFkMYaQSj4noL1ravXdrpx8mQ.jpg"},
    {"name": "سلسلة ذهب قلب ناعمة عيار 18", "category": "سلاسل", "karat": "18", "weight": 3.5, "stoneWeight": 0.0, "rating": 4.7, "image": "assets/images/necklaces/0583aeea-cca0-4de4-9a21-18ab9c75f1dc-1000x1000-AshRV8gxMzv3nFLiTxva4A6dktd6pDMBGCbjZfu8.jpg"},
    {"name": "عقد ذهب عيار 21 ملكي", "category": "سلاسل", "karat": "21", "weight": 15.0, "stoneWeight": 1.0, "rating": 5.0, "image": "assets/images/necklaces/3c3917a0-496a-4bff-84c0-e8fba53fb73d-1000x1000-9N3afKX5MCx2jgQYRTcfiU7tv0x0XvT9LP31fjQH.jpg"},
    {"name": "سلسلة ذهب بسيطة عيار 18", "category": "سلاسل", "karat": "18", "weight": 2.5, "stoneWeight": 0.0, "rating": 4.5, "image": "assets/images/necklaces/36cba420-9f58-446f-b21c-929407f530f4-1000x1000-OCzbpV1GvsqK6WuU9biCZeUd8EFlB6HnBUvddAau.jpg"},
    {"name": "عقد ذهب عيار 21 مزخرف", "category": "سلاسل", "karat": "21", "weight": 11.0, "stoneWeight": 0.0, "rating": 4.6, "image": "assets/images/necklaces/4a054876-f866-449f-bf77-44bd009ede05-1000x1000-j4830T4RTmbcSqTPbjCRhUsQTET8eSnT4V0teBvh.jpg"},
    {"name": "سلسلة ذهب طويلة عيار 21", "category": "سلاسل", "karat": "21", "weight": 8.0, "stoneWeight": 0.0, "rating": 4.8, "image": "assets/images/necklaces/a04b28fb-e146-484d-93cb-f44328fa4d74-1000x1000-dGgEsBDV5HBcYlnDRaBg4Sq5l2uKOKJ6Ul0LlN18.jpg"},
    {"name": "عقد ذهب عيار 18 عصري", "category": "سلاسل", "karat": "18", "weight": 6.5, "stoneWeight": 0.0, "rating": 4.4, "image": "assets/images/necklaces/b22358a7-0411-48f7-81ea-dc5caf4ce9f3-1000x1000-x0dAUEihMXDkP1mns2fA8Ti18cAd25lOjfEuqIjh.jpg"},
    {"name": "سلسلة ذهب ناعمة جداً عيار 18", "category": "سلاسل", "karat": "18", "weight": 2.8, "stoneWeight": 0.0, "rating": 4.6, "image": "assets/images/necklaces/ddaf2caf-70f7-482f-8ad4-9ad91717af88-1000x1000-VVuZzvLNscucRRwoJVldyicBaYCouLP4KqH5OZG3.jpg"},
    {"name": "عقد ذهب عيار 21 بحريني", "category": "سلاسل", "karat": "21", "weight": 13.5, "stoneWeight": 0.0, "rating": 4.9, "image": "assets/images/necklaces/e6e76181-87a5-452b-a277-2ebf09fed433-1000x1000-n6jpHWRslufTj6mhXjibEXUoGYjB37A5Mkp3pI6i.jpg"},
    {"name": "سلسلة ذهب كلاسيكية عيار 21", "category": "سلاسل", "karat": "21", "weight": 9.5, "stoneWeight": 0.0, "rating": 4.7, "image": "assets/images/necklaces/f16ce963-ccf8-4eb5-9f2d-f694f026f926-1000x1000-DQVveWJTHhooFw5QeD1RcUoi6QW1oQ197kIqIR9p.jpg"},
    {"name": "عقد ذهب عيار 21 فخم", "category": "سلاسل", "karat": "21", "weight": 17.5, "stoneWeight": 0.8, "rating": 5.0, "image": "assets/images/necklaces/f1e0d0fe-31be-4352-a332-6fa2b2febc45-1000x1000-KasxCLJDg32BMdfz9WD7kJWtrob4wKSmQmzU6Gy4.jpg"},
  ];

  static const List<Map<String, String>> categories = [
    {"name": "خواتم", "image": "assets/images/rings/12.webp"},
    {"name": "سلاسل", "image": "assets/images/necklaces/bd424935-658d-4665-b47f-b783be3beb41-1000x1000-wYoawOxrbvxt64muFkMYaQSj4noL1ravXdrpx8mQ.jpg"},
    {"name": "اساور", "image": "assets/images/bracelets/8.webp"},
    {"name": "اقراط", "image": "assets/images/earrings/17.webp"},
    {"name": "طقم كامل", "image": "assets/images/sets/21.webp"},
    {"name": "خلخال", "image": "assets/images/anklets/33.webp"},
    {"name": "غوايش", "image": "assets/images/bangles/2.webp"},
    {"name": "كفوف", "image": "assets/images/gloves/27.webp"},
  ];
}
