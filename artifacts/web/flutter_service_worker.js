'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"icons/Icon-maskable-512.png": "ae6a42b122e3b86f17c13ee8aa11d044",
"icons/Icon-192.png": "3650e0b4336642b0f6d3c21268115759",
"icons/Icon-512.png": "9f97961d2502ab14950edef857dfddc5",
"icons/Icon-maskable-192.png": "1c548ae03b60e75e0ad46dddf4011e55",
"assets/FontManifest.json": "0a67ef630d5c8de22897343658d3e9b8",
"assets/AssetManifest.bin.json": "8b1a7f70ee6e0b7b7345a1ba457cdf90",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/assets/images/triangle_alert.png": "17852c8ee32276e2b25dbd36c9d697e5",
"assets/assets/images/error.svg": "7224f3923ea5adda3b446b1b0d245a2b",
"assets/assets/images/treatment_home.png": "1ca7852504add1073ee9718eb3c587d8",
"assets/assets/images/ad_free.svg": "028c4aeda2b973642d97c5fd6744d4f8",
"assets/assets/images/check_icon_black.svg": "1616850f3a5123d2a226dcf945e740e7",
"assets/assets/images/home.svg": "9696f73c59bb65f7e39d2461662915af",
"assets/assets/images/numaze_logo.png": "a26529d6bf895a3a7156b50f7bf48c3c",
"assets/assets/images/visited.svg": "dcd53180504ccde8c21277a38da6cba9",
"assets/assets/images/clipboard.svg": "ebbe6b2a166111e63aefb009ba83da37",
"assets/assets/images/line_check.svg": "dd9ebcda484746008f7fd8d65dd652ef",
"assets/assets/images/ads.svg": "63101a5023dc6787c29564e6e63462af",
"assets/assets/images/find_reservation.svg": "717376068766a3e173fb4417ae5eee20",
"assets/assets/images/customer_appointment.svg": "d77637a3c3660157db6ebcc8e4609358",
"assets/assets/images/close.svg": "a7a7bdf8fb215ceb8455067142071330",
"assets/assets/images/calendar_right_arrow.svg": "e0ed7a775638399d3b4dc412595587bc",
"assets/assets/images/absent.svg": "5a1ca8ba1a731751178c5d29cb798db2",
"assets/assets/images/add_60.svg": "500fb0c4c6834fdacf15fb78d7ff083a",
"assets/assets/images/add.svg": "84946687f1944f528c8cf1d86083be40",
"assets/assets/images/confirmed.svg": "67aa96abdf5e55f2497e14f7b17b0976",
"assets/assets/images/empty_treatment.svg": "7f31fdd9720db4c5c2467700f8364a06",
"assets/assets/images/line_arrow_right.svg": "947c662f11bf5a21e833be67bf9a6fca",
"assets/assets/images/alert.svg": "0dd82829456f8f3f769ec84d6ab1bc05",
"assets/assets/images/triangle_alert.svg": "f4ff3453ecf778cc2c416106f2522fa6",
"assets/assets/images/right_arrow.svg": "09072da0f05969eccd74f8b0336e2d26",
"assets/assets/images/treatment_home.svg": "fe9211430dff662a44612d33be781298",
"assets/assets/images/has_treatment_check_black.svg": "92a5c7d30e27a3c0c1ca0ea3e04a518c",
"assets/assets/images/calendar_left_arrow.svg": "cf9954294b312d7eb98cca881517e3ff",
"assets/assets/images/payment_complete.svg": "9e717fbc04e8c3bc35227b0db9b5e7fb",
"assets/assets/images/line_check_black.svg": "973f7a56e7e7309fb69fc034391f83f4",
"assets/assets/images/cancel.svg": "f77af8b3fe183fbaab2fb195793b9655",
"assets/assets/images/arrow_down_14.svg": "0e70e8d440f4204a046f303d783066d1",
"assets/assets/images/arrow_down.svg": "aa69f8f580f463f8b9f0d769bfd0498c",
"assets/assets/images/check_icon.svg": "6e1f3d8c884a93e87f24b6221ac1456e",
"assets/assets/images/line_close.svg": "108581c309ba72eadc9b7d15c01b6c2d",
"assets/assets/images/complete.svg": "6af1b8db2fc55e7167103cdb90fcc4e9",
"assets/assets/images/line_arrow_down.svg": "01b6926ba6abe46edb6eb80733e959b7",
"assets/assets/images/line_arrow_up.svg": "77248cd6e9c5d121192a38c72c0c86aa",
"assets/assets/images/white_check.svg": "f0844a648078909e027730ffb6981fdd",
"assets/assets/images/clock.svg": "cd3294bdb17c81c0bd18f9971e09baea",
"assets/assets/images/has_treatment_check.svg": "0fdb69040a0f608f7b9dfb5693acc2c7",
"assets/fonts/Pretendard-Regular.ttf": "d6e0de06bff8b7fda2db4682168e3ddf",
"assets/fonts/Pretendard-SemiBold.ttf": "459eff7ba5380583ccd6eda49c846c85",
"assets/fonts/MaterialIcons-Regular.otf": "1e368baea4280d80734dc3480b7ee829",
"assets/fonts/Pretendard-Medium.ttf": "7305f90c923d4409825ec2f4380b63d6",
"assets/fonts/Pretendard-Bold.ttf": "dfb614ebecd405875f50a918ca11c17c",
"assets/AssetManifest.bin": "7e15afea95180676767ac6651d15188c",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/flutter_image_compress_web/assets/pica.min.js": "6208ed6419908c4b04382adc8a3053a2",
"assets/AssetManifest.json": "0ba0a9efdb113552f0fb4dc5f9e09e30",
"assets/NOTICES": "b0f8566bb3ec7f86ad2f65d2457a6b96",
"index.html": "4ed779413516c6fbbd928cc0ce44656f",
"/": "4ed779413516c6fbbd928cc0ce44656f",
"main.dart.js": "46447798f1a6313f51243aff5d9ce5c7",
"favicon.png": "1eea1611eda5d1b080e5c75c0129cc6d",
"version.json": "edbe95246bf0083643aa131546d79d58",
"flutter_bootstrap.js": "1c090a7e7a6a59811709a7e7f0c1560d",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.js": "87325e67bf77a9b483250e1fb1b54677",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/canvaskit.js": "5fda3f1af7d6433d53b24083e2219fa0",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"canvaskit/skwasm.js": "9fa2ffe90a40d062dd2343c7b84caf01",
"manifest.json": "953ebbad00d4046427ed3203c610b2e4",
"flutter.js": "f31737fb005cd3a3c6bd9355efd33061"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
