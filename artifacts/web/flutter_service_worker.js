'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/NOTICES": "6c62af24be2c0818d44bf68f67ad9db9",
"assets/AssetManifest.bin.json": "e3f7720195ad6953f251fb35f27585d0",
"assets/FontManifest.json": "0a67ef630d5c8de22897343658d3e9b8",
"assets/assets/images/line_check.svg": "dd9ebcda484746008f7fd8d65dd652ef",
"assets/assets/images/calendar_left_arrow.svg": "cf9954294b312d7eb98cca881517e3ff",
"assets/assets/images/red_error.svg": "ddab536f513afc2b145cce792b93bcff",
"assets/assets/images/arrow_down.svg": "aa69f8f580f463f8b9f0d769bfd0498c",
"assets/assets/images/absent.png": "15b9e3b9dde2cd2e427a03b44d820149",
"assets/assets/images/find_reservation.svg": "717376068766a3e173fb4417ae5eee20",
"assets/assets/images/treatment_home.svg": "fe9211430dff662a44612d33be781298",
"assets/assets/images/has_treatment_check_black.svg": "92a5c7d30e27a3c0c1ca0ea3e04a518c",
"assets/assets/images/triangle_alert.png": "17852c8ee32276e2b25dbd36c9d697e5",
"assets/assets/images/numaze_logo.png": "a26529d6bf895a3a7156b50f7bf48c3c",
"assets/assets/images/close.svg": "a7a7bdf8fb215ceb8455067142071330",
"assets/assets/images/line_arrow_down.svg": "01b6926ba6abe46edb6eb80733e959b7",
"assets/assets/images/has_treatment_check.svg": "0fdb69040a0f608f7b9dfb5693acc2c7",
"assets/assets/images/white_check.svg": "f0844a648078909e027730ffb6981fdd",
"assets/assets/images/check_icon.svg": "6e1f3d8c884a93e87f24b6221ac1456e",
"assets/assets/images/confirmed.svg": "67aa96abdf5e55f2497e14f7b17b0976",
"assets/assets/images/alert.svg": "0dd82829456f8f3f769ec84d6ab1bc05",
"assets/assets/images/line_check_black.svg": "973f7a56e7e7309fb69fc034391f83f4",
"assets/assets/images/triangle_alert.svg": "f4ff3453ecf778cc2c416106f2522fa6",
"assets/assets/images/line_close.png": "a66022b13166394ffb43b8ff97c8c11c",
"assets/assets/images/add_60.svg": "500fb0c4c6834fdacf15fb78d7ff083a",
"assets/assets/images/ads.svg": "63101a5023dc6787c29564e6e63462af",
"assets/assets/images/clock.svg": "1bb816ce19d4bbe478c12a7e601a534a",
"assets/assets/images/complete.svg": "6af1b8db2fc55e7167103cdb90fcc4e9",
"assets/assets/images/line_close.svg": "108581c309ba72eadc9b7d15c01b6c2d",
"assets/assets/images/cancel.svg": "f77af8b3fe183fbaab2fb195793b9655",
"assets/assets/images/home.svg": "9696f73c59bb65f7e39d2461662915af",
"assets/assets/images/absent.svg": "5a1ca8ba1a731751178c5d29cb798db2",
"assets/assets/images/visited.svg": "dcd53180504ccde8c21277a38da6cba9",
"assets/assets/images/line_arrow_up.svg": "77248cd6e9c5d121192a38c72c0c86aa",
"assets/assets/images/clipboard.svg": "ebbe6b2a166111e63aefb009ba83da37",
"assets/assets/images/right_arrow.svg": "09072da0f05969eccd74f8b0336e2d26",
"assets/assets/images/line_arrow_right.svg": "947c662f11bf5a21e833be67bf9a6fca",
"assets/assets/images/empty_treatment.svg": "7f31fdd9720db4c5c2467700f8364a06",
"assets/assets/images/add.svg": "84946687f1944f528c8cf1d86083be40",
"assets/assets/images/find_reservation.png": "b4d3daa9bc6ad3fdb355441b20346845",
"assets/assets/images/ad_free.svg": "028c4aeda2b973642d97c5fd6744d4f8",
"assets/assets/images/check.svg": "7824042e62a953ce6b4e0a7039a4a312",
"assets/assets/images/payment_complete.svg": "9e717fbc04e8c3bc35227b0db9b5e7fb",
"assets/assets/images/error.svg": "7224f3923ea5adda3b446b1b0d245a2b",
"assets/assets/images/treatment_home.png": "1ca7852504add1073ee9718eb3c587d8",
"assets/assets/images/customer_appointment.svg": "d77637a3c3660157db6ebcc8e4609358",
"assets/assets/images/calendar_right_arrow.svg": "e0ed7a775638399d3b4dc412595587bc",
"assets/assets/images/check_icon_black.svg": "1616850f3a5123d2a226dcf945e740e7",
"assets/fonts/MaterialIcons-Regular.otf": "1e368baea4280d80734dc3480b7ee829",
"assets/fonts/Pretendard-Medium.ttf": "7305f90c923d4409825ec2f4380b63d6",
"assets/fonts/Pretendard-Bold.ttf": "dfb614ebecd405875f50a918ca11c17c",
"assets/fonts/Pretendard-SemiBold.ttf": "459eff7ba5380583ccd6eda49c846c85",
"assets/fonts/Pretendard-Regular.ttf": "d6e0de06bff8b7fda2db4682168e3ddf",
"assets/AssetManifest.json": "1a936463c4b20844d0c30f40f15a1097",
"assets/AssetManifest.bin": "2d8d08cd9dbee5f5377cc4e7170c9223",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"index.html": "e58389126a447ec92fc63b7f75eecbf9",
"/": "e58389126a447ec92fc63b7f75eecbf9",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c",
"canvaskit/canvaskit.wasm": "9251bb81ae8464c4df3b072f84aa969b",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"canvaskit/canvaskit.js": "738255d00768497e86aa4ca510cce1e1",
"canvaskit/canvaskit.js.symbols": "74a84c23f5ada42fe063514c587968c6",
"canvaskit/skwasm.wasm": "4051bfc27ba29bf420d17aa0c3a98bce",
"canvaskit/skwasm.js.symbols": "c3c05bd50bdf59da8626bbe446ce65a3",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/chromium/canvaskit.wasm": "399e2344480862e2dfa26f12fa5891d7",
"canvaskit/chromium/canvaskit.js": "901bb9e28fac643b7da75ecfd3339f3f",
"canvaskit/chromium/canvaskit.js.symbols": "ee7e331f7f5bbf5ec937737542112372",
"flutter_bootstrap.js": "7a013b36637d4febe3b232799a5b2be5",
"main.dart.js": "7dab8961ffde255292e5074db4a618d0",
"icons/Icon-maskable-512.png": "ae6a42b122e3b86f17c13ee8aa11d044",
"icons/Icon-maskable-192.png": "1c548ae03b60e75e0ad46dddf4011e55",
"icons/Icon-512.png": "9f97961d2502ab14950edef857dfddc5",
"icons/Icon-192.png": "3650e0b4336642b0f6d3c21268115759",
"manifest.json": "815dd85e208b3fc2332a09e931845dc3",
"version.json": "edbe95246bf0083643aa131546d79d58",
"favicon.png": "b20319f00335a4b921bbc27c85b94e6a",
"swipe_back.js": "94641c3be33c5f06906f02e4372953c6"};
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
