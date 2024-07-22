'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"manifest.json": "953ebbad00d4046427ed3203c610b2e4",
"canvaskit/canvaskit.js": "738255d00768497e86aa4ca510cce1e1",
"canvaskit/canvaskit.js.symbols": "74a84c23f5ada42fe063514c587968c6",
"canvaskit/chromium/canvaskit.js": "901bb9e28fac643b7da75ecfd3339f3f",
"canvaskit/chromium/canvaskit.js.symbols": "ee7e331f7f5bbf5ec937737542112372",
"canvaskit/chromium/canvaskit.wasm": "399e2344480862e2dfa26f12fa5891d7",
"canvaskit/canvaskit.wasm": "9251bb81ae8464c4df3b072f84aa969b",
"canvaskit/skwasm.wasm": "4051bfc27ba29bf420d17aa0c3a98bce",
"canvaskit/skwasm.js.symbols": "c3c05bd50bdf59da8626bbe446ce65a3",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c",
"flutter_bootstrap.js": "5b5d9363902c9f9ca3f412f495258e08",
"version.json": "edbe95246bf0083643aa131546d79d58",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "d865ac9358da4e9bcc49296ac28c6ebf",
"assets/NOTICES": "2602449c76151fe446357f2d3a2f4cb8",
"assets/AssetManifest.bin": "4818abac4d87c504fbec1da78827743d",
"assets/FontManifest.json": "0a67ef630d5c8de22897343658d3e9b8",
"assets/AssetManifest.bin.json": "a090cf15e0fc5fde058ac79c9169c9af",
"assets/assets/images/cancel.png": "13d561c7d68b278854502a6b73c9973c",
"assets/assets/images/absent.svg": "5a1ca8ba1a731751178c5d29cb798db2",
"assets/assets/images/complete.svg": "6af1b8db2fc55e7167103cdb90fcc4e9",
"assets/assets/images/confirmed.svg": "271fd450a97db1ff4e1c2a1d5d63cce7",
"assets/assets/images/check.svg": "7824042e62a953ce6b4e0a7039a4a312",
"assets/assets/images/right_arrow.svg": "09072da0f05969eccd74f8b0336e2d26",
"assets/assets/images/customer_appointment.svg": "d77637a3c3660157db6ebcc8e4609358",
"assets/assets/images/close.svg": "a7a7bdf8fb215ceb8455067142071330",
"assets/assets/images/calendar_left_arrow.svg": "cf9954294b312d7eb98cca881517e3ff",
"assets/assets/images/alert.svg": "0dd82829456f8f3f769ec84d6ab1bc05",
"assets/assets/images/calendar_right_arrow.svg": "e0ed7a775638399d3b4dc412595587bc",
"assets/assets/images/confirmed.png": "7e5a0a4219c480308f8893bba77d5b4f",
"assets/assets/images/visited.svg": "b9838148feffbe26f6d985541c6463a6",
"assets/assets/images/arrow_down.svg": "aa69f8f580f463f8b9f0d769bfd0498c",
"assets/assets/images/triangle_alert.png": "17852c8ee32276e2b25dbd36c9d697e5",
"assets/assets/images/line_close.svg": "108581c309ba72eadc9b7d15c01b6c2d",
"assets/assets/images/complete.png": "f371d487bb35f59afba610c36eadf76c",
"assets/assets/images/clock.svg": "1bb816ce19d4bbe478c12a7e601a534a",
"assets/assets/images/empty_treatment.svg": "7f31fdd9720db4c5c2467700f8364a06",
"assets/assets/images/find_reservation.svg": "717376068766a3e173fb4417ae5eee20",
"assets/assets/images/find_reservation.png": "b4d3daa9bc6ad3fdb355441b20346845",
"assets/assets/images/ad_free.svg": "028c4aeda2b973642d97c5fd6744d4f8",
"assets/assets/images/line_close.png": "a66022b13166394ffb43b8ff97c8c11c",
"assets/assets/images/visited.png": "47cdc09527e9731e17618c1dd47744c0",
"assets/assets/images/cancel.svg": "294eeed66c4899f158bec8108c1d6ce3",
"assets/assets/images/triangle_alert.svg": "f4ff3453ecf778cc2c416106f2522fa6",
"assets/assets/images/payment_complete.svg": "9e717fbc04e8c3bc35227b0db9b5e7fb",
"assets/assets/images/home.svg": "9696f73c59bb65f7e39d2461662915af",
"assets/assets/images/numaze_logo.png": "1ab56d7c7b2cfa12aaafa23e58f44734",
"assets/assets/images/absent.png": "15b9e3b9dde2cd2e427a03b44d820149",
"assets/fonts/Pretendard-Bold.ttf": "dfb614ebecd405875f50a918ca11c17c",
"assets/fonts/Pretendard-SemiBold.ttf": "459eff7ba5380583ccd6eda49c846c85",
"assets/fonts/MaterialIcons-Regular.otf": "251a89ddb453784aec8d413360f8c84b",
"assets/fonts/Pretendard-Regular.ttf": "d6e0de06bff8b7fda2db4682168e3ddf",
"assets/fonts/Pretendard-Medium.ttf": "7305f90c923d4409825ec2f4380b63d6",
"assets/AssetManifest.json": "e838a5e2c3f62896c0f3725c5650e86f",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"index.html": "e21880bcf28a91856d2c988c9d531f15",
"/": "e21880bcf28a91856d2c988c9d531f15",
"main.dart.js": "8e45bdd4e908422b409ac7f2038aa6a8"};
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
