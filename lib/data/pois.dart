import '../models/poi.dart';

// Batch 1: Mohegan Bluffs, Southeast Light, North Light
// Sourced from Wikipedia, blockislandinfo.com, newshorehamri.gov, blockislandferry.com
// See accompanying notes for unresolved source conflicts (heights, distances, battle dating).

const moheganBluffs = Poi(
  id: 'mohegan-bluffs',
  name: 'Mohegan Bluffs',
  shortDescription: 'Clay cliffs over 150 feet high, with stairs to the beach',
  description:
      'Mohegan Bluffs is a stretch of clay cliffs running along Block '
      'Island\'s southern shore, rising over 150 feet above the Atlantic. '
      'The cliffs extend for close to three miles along the coast, and the '
      'Southeast Light sits at their edge.\n\n'
      'A staircase of 141 steps switchbacks down the bluff face to the '
      'beach below, known locally as Corn Cove. The stairs are steep, and '
      'the descent ends with a short scramble over rocks before you reach '
      'the sand.\n\n'
      'The bluffs are actively eroding. Storms and wave action have worn '
      'the cliff edge back over time, which is why the Southeast Light '
      '(originally built much closer to the edge) had to be physically '
      'relocated inland in 1993. Posted signs mark the current safe '
      'boundary, and visitors are asked to stay behind them.\n\n'
      'The bluffs take their name from a battle fought here between the '
      'Mohegan and the island\'s native people. TODO(luke): sources disagree '
      'on the date (16th century vs. 1590) and on which tribe is named as '
      'the island\'s defenders (Niantic vs. Manissean) — needs a primary '
      'source before this goes further than "named for a Native American '
      'battle."',
  category: PoiCategory.shore,
  lat: 41.153253,
  lng: -71.555159,
  imageAsset: 'assets/images/mohegan-bluffs.jpg',
  visitorNote:
      'The stairs to the beach are steep — 141 steps down, plus a rock '
      'scramble at the bottom — and the climb back up is harder than the '
      'descent. Not suitable for visitors with limited mobility. No '
      'restrooms or lifeguards at the beach.',
  questIds: [],
  moduleIds: [],
);

const southeastLight = Poi(
  id: 'southeast-light',
  name: 'Southeast Light',
  shortDescription: '1875 lighthouse atop Mohegan Bluffs, moved inland in 1993',
  description:
      'Southeast Light is a brick lighthouse standing at the edge of '
      'Mohegan Bluffs, first lit on February 1, 1875. Its octagonal tower '
      'stands 52 feet tall on a granite and brick base, with a keeper\'s '
      'dwelling attached — built in a Gothic Revival style that was '
      'unusually ornate for a working lighthouse of its time.\n\n'
      'Because the tower sits atop the bluffs, its light has a focal '
      'height of 261 feet above sea level, giving it a range of 20 '
      'nautical miles. It was designated a National Historic Landmark in '
      '1997, recognized in part because it was one of only twelve '
      'lighthouses in the country still using a first-order Fresnel lens '
      'at the time.\n\n'
      'Erosion of the bluffs put the original structure at risk, so in '
      '1993 the entire 2,000-ton building was moved back roughly 300 feet '
      'from the cliff edge — moved whole, not disassembled. The Coast '
      'Guard deactivated the light in 1990 and it now operates on an '
      'automated fixed lens (a first-order lens salvaged from North '
      'Carolina\'s Cape Lookout Lighthouse) rather than the rotating '
      'mercury-float lens it used historically.\n\n'
      'The lighthouse has been owned and maintained by the Southeast '
      'Lighthouse Foundation since 1992, which operates a small museum '
      'and gift shop in the tower base.',
  category: PoiCategory.historic,
  lat: 41.153573,
  lng: -71.552072,
  imageAsset: 'assets/images/southeast-light.jpg',
  visitorNote:
      'Tower interior is only open via guided tour during the summer '
      'season; grounds are open year-round. TODO(luke): current tour fee '
      'and season dates needed — the only figure I found (\$15) was dated '
      'June 2024 and may be stale by launch.',
  questIds: [],
  moduleIds: [],
);

const northLight = Poi(
  id: 'north-light',
  name: 'North Light',
  shortDescription: '1867 granite lighthouse at Block Island\'s north tip',
  description:
      'North Light stands at Sandy Point on the northern tip of Block '
      'Island. The current structure, built of granite in 1867, is the '
      'fourth lighthouse on this site — the previous three were lost '
      'within 38 years to storms and the shifting sandbar at the point. '
      'It cost \$15,000 to build and served as the design template for '
      'five sister lighthouses, three in Connecticut and two in New York.\n\n'
      'The light was deactivated in 1973 and the property passed to the '
      'U.S. Fish and Wildlife Service. After years of disuse, the Town of '
      'New Shoreham bought the lighthouse and two acres around it for \$1 '
      'in 1984. Volunteers and the North Light Commission restored it, '
      'and the light was relit in 1989; a museum opened on the ground '
      'floor in 1993. The tower itself underwent further restoration at '
      'Georgetown Ironworks in Massachusetts starting in 2008, returning '
      'for a relighting ceremony on October 23, 2010.\n\n'
      'There\'s no vehicle access to the lighthouse itself — you park at '
      'Settler\'s Rock, a monument to the island\'s original English '
      'settler families, and walk about half a mile across the beach to '
      'reach it. Beyond the lighthouse lies Sachem Pond, a wildlife '
      'refuge for gulls, terns, and other shorebirds.',
  category: PoiCategory.historic,
  lat: 41.227844,
  lng: -71.575921,
  imageAsset: 'assets/images/north-light.jpg',
  visitorNote:
      'No tower access — only the first-floor museum is open to the '
      'public, and only in season. Reaching the lighthouse means a '
      'half-mile walk on a rocky/sandy beach from the Settler\'s Rock '
      'parking area; there\'s no paved path. The surrounding shoreline has '
      'strong currents where waters from both sides of the island meet, '
      'so it\'s not a swimming spot.',
  questIds: [],
  moduleIds: [],
);

const poiBatch1 = <Poi>[
  moheganBluffs,
  southeastLight,
  northLight,
];

// Batch 2: 7 trail, 14 shore, 4 organization, 2 landmark, 1 historic.
// Wildlife preserves map to trail; the Historical Society stays historic.
const poiBatch2 = <Poi>[
  // ───────────────────────── TRAILS ─────────────────────────

  Poi(
    id: 'block-island-greenway-traverse',
    name: 'Block Island Greenway Traverse',
    shortDescription: '5.6-mile one-way trail, Payne Rd to Beacon Hill Rd',
    description:
        "The Greenway Traverse is a 5.6-mile point-to-point trail from Payne Road to Beacon Hill Road. It is one section of the Greenway, a network of free public walking trails covering more than 28 miles of the island. Block Island Tourism rates it moderately challenging and puts the average time at about two hours.\n\n"
        "The Greenway opened in 1989, linking Rodman's Hollow with Turnip Farm. A former Nature Conservancy staffer, Keith Lang, had suggested it in the late 1980s, inspired by the public footpaths of England. Look for stone markers or wooden signs to confirm you are on it.\n\n"
        "TODO(luke): source needed for trailhead locations and parking at each end.",
    category: PoiCategory.trail,
    lat: 41.180687,
    lng: -71.586207,
    imageAsset: 'assets/images/block-island-greenway-traverse.jpg',
    questIds: [],
    moduleIds: [],
  ),

  Poi(
    id: 'clay-head-trail',
    name: 'Clay Head Trail',
    shortDescription: "Bluff trail and unmarked 'Maze' paths, northeast shore",
    description:
        "Clay Head is a 190-acre preserve at the north end of the island. The land is privately owned, protected by conservation easements, and open to the public. The Nature Conservancy lists it as one of the best places in North America to watch migratory songbirds in spring and fall. The main trail is about 3.5 miles.\n\n"
        "From the trailhead the path runs about a third of a mile east toward the ocean, past Clay Head Swamp with Littlefield Farm behind it. At the first intersection, right leads to the beach and left climbs onto the clay bluffs the preserve is named for. Along the bluff, side paths branch inland. That tangle is the 'Maze'.\n\n"
        "The Maze trails are unmarked and not mapped as a loop, so it is normal to wander and double back.",
    category: PoiCategory.trail,
    lat: 41.208543,
    lng: -71.562126,
    imageAsset: 'assets/images/clay-head-trail.jpg',
    visitorNote:
        'Private land open through conservation easements. Side paths in the Maze are unmarked.',
    questIds: [],
    moduleIds: [],
  ),

  Poi(
    id: 'rodmans-hollow',
    name: "Rodman's Hollow",
    shortDescription: '230-acre glacial basin with about 3.5 miles of trails',
    description:
        "Rodman's Hollow is a 230-acre glacial outwash basin in the southwest part of the island, off Cooneymus Road. The preserve has just over 3.5 miles of walking trails, and the trailhead is about 500 feet from the overlook. It is named for John Rodman, a physician and Quaker minister who lived on Block Island in the late 1600s.\n\n"
        "It is also where island conservation started. In 1972 a developer who had bought 37 acres of the Hollow planned a dozen luxury homes there. Residents formed the Block Island Conservancy to stop it, and the Nature Conservancy joined in. The first 37 acres took four years to acquire. The preserve now holds 230 acres, owned and managed by the Block Island Conservancy, the state Department of Environmental Management, the Town of New Shoreham and The Nature Conservancy.\n\n"
        "The shrubland is good habitat for northern harriers, a large hawk that the Nature Conservancy says nests nowhere else in Rhode Island.",
    category: PoiCategory.trail,
    lat: 41.159574,
    lng: -71.591231,
    imageAsset: 'assets/images/rodmans-hollow.jpg',
    visitorNote: 'Bicycles are not allowed on the Rodman\'s Hollow trails.',
    questIds: [],
    moduleIds: [],
  ),

  Poi(
    id: 'nathan-mott-park',
    name: 'Nathan Mott Park',
    shortDescription: 'First conserved land on the island; meadow hill trail',
    description:
        "Nathan Mott Park was the first property conserved on Block Island. In 1941 Lucretia Mott Ball set it up in honor of her father, whose family had farmed the land. The trail crosses an open meadow to the top of a hill with a view east over town to the Clay Head bluffs, and connects to miles of trail in the protected land around it.\n\n"
        "The park was once much bigger. It began as a 77-acre farm; the state later took 21 acres for the airport runways (1949) and 13 more for approach lights (1961), and a few acres went to the Harbor Baptist Church in 1990. It is now about 40 acres, owned and managed by the Block Island Conservancy.",
    category: PoiCategory.trail,
    lat: 41.168915,
    lng: -71.583423,
    imageAsset: 'assets/images/nathan-mott-park.jpg',
    questIds: [],
    moduleIds: [],
  ),

  Poi(
    id: 'dickens-point',
    name: 'Dickens Point',
    shortDescription: 'Short out-and-back trail for watching wildlife',
    description:
        "Dickens Point is a short out-and-back trail, listed at 0.66 miles with about 82 feet of elevation gain, that gives a chance to see wildlife.\n\n"
        "TODO(luke): source needed for where the trail starts, who owns it, how it relates to the Dickens farm properties, and what wildlife to expect. The only source found was a user-submitted trail listing.",
    category: PoiCategory.trail,
    lat: 41.151833,
    lng: -71.608502,
    imageAsset: 'assets/images/dickens-point.jpg',
    questIds: [],
    moduleIds: [],
  ),

  // ──────────────────── WILDLIFE (preserves) ────────────────────

  Poi(
    id: 'lewis-dickens-farm',
    name: 'Lewis-Dickens Farm',
    shortDescription: '120-acre coastal meadow refuge on Cooneymus Road',
    description:
        "Lewis-Dickens Farm is a 120-acre Audubon Society of Rhode Island wildlife refuge on Cooneymus Road. Two easy trails cross coastal meadows with views over the Atlantic. Raptors and fall migrants are the draw: barn owl, northern harrier, peregrine falcon, merlin and American kestrel are all listed. Look for deer and the Block Island meadow vole too.\n\n"
        "The name honors Elizabeth Dickens (1877-1963), the 'Bird Lady of Block Island', and the Lewis family. Her bird collection is now kept at the Block Island School. The farm itself was a mid-19th-century property of about 200 acres, and The Nature Conservancy bought 141 acres of it in 1982 to keep it open.",
    category: PoiCategory.trail,
    lat: 41.153248,
    lng: -71.606923,
    imageAsset: 'assets/images/lewis-dickens-farm.jpg',
    visitorNote: 'Dogs are prohibited. No restrooms. Open sunrise to sunset.',
    questIds: [],
    moduleIds: [],
  ),

  Poi(
    id: 'hodge-preserve',
    name: 'Hodge Family Wildlife Preserve',
    shortDescription: '25-acre meadow loop beside Middle Pond',
    description:
        "The Hodge Family Wildlife Preserve is a 25-acre property managed by The Nature Conservancy. A mostly level loop of about a mile is mowed through goldenrod fields, with views of Middle Pond and Great Salt Pond to the west. It is a stopover for migratory songbirds and home to northern harriers and the Block Island meadow vole. It connects to the Block Island National Wildlife Refuge.\n\n"
        "The hardest part of Hodge is finding it. Trail maps are free at the Visitor Center and the Nature Conservancy office.",
    category: PoiCategory.trail,
    lat: 41.213471,
    lng: -71.567002,
    imageAsset: 'assets/images/hodge-preserve.jpg',
    visitorNote: 'The trailhead is easy to miss. Bring a trail map.',
    questIds: [],
    moduleIds: [],
  ),

  // ───────────────────────── BEACHES ─────────────────────────

  Poi(
    id: 'surf-beach',
    name: 'Surf Beach',
    shortDescription: 'South end of Crescent Beach; best snorkeling spot',
    description:
        "Surf Beach is the south end of Crescent Beach, named for the Surf Hotel above it and a three-minute walk from the ferry landing. Rock formations and a breakwater make it the island's best snorkeling spot, with small crabs, starfish, shells and sand dollars. The water stays shallow a long way out.\n\n"
        "Access is through the Surf Hotel or by a path in the center of town, across from the National Hotel or across from the library. The Surf Hotel rents snorkeling gear.",
    category: PoiCategory.shore,
    lat: 41.174641,
    lng: -71.559672,
    imageAsset: 'assets/images/surf-beach.jpg',
    questIds: [],
    moduleIds: [],
  ),

  Poi(
    id: 'baby-beach',
    name: 'Baby Beach',
    shortDescription: 'Sheltered, shallow beach just north of Old Harbor',
    description:
        "Baby Beach is the stretch of Crescent Beach just south of the Fred Benson pavilion, practically in Old Harbor. The surf is gentle and the water shallow, which is why local families bring young children here.\n\n"
        "A short path leads in from Corn Neck Road parking. Look for two posts near the corner with Beach Avenue.",
    category: PoiCategory.shore,
    lat: 41.175677,
    lng: -71.561572,
    imageAsset: 'assets/images/baby-beach.jpg',
    visitorNote:
        'No lifeguard. The nearest staffed beach is Fred Benson Town Beach, just north.',
    questIds: [],
    moduleIds: [],
  ),

  Poi(
    id: 'fred-benson-town-beach',
    name: 'Fred Benson Town Beach',
    shortDescription: 'Crescent Beach pavilion: lifeguards, food, rentals',
    description:
        "Fred Benson Town Beach is the middle of Crescent Beach, at 7 Corn Neck Road. Locals also call it Crescent Beach or Benson Beach. The Frederick J. Benson Pavilion has a concession stand, changing rooms, showers and restrooms, and rents chairs, umbrellas, cabanas and boogie boards.\n\n"
        "It was once called State Beach and is now owned and run by the town. Lifeguards are on duty in the summer season, and parking and entry are free. It is one of only two beaches on the island with lifeguards, along with Ballard's.",
    category: PoiCategory.shore,
    lat: 41.182802,
    lng: -71.565811,
    imageAsset: 'assets/images/fred-benson-town-beach.jpg',
    questIds: [],
    moduleIds: [],
  ),

  Poi(
    id: 'scotch-beach',
    name: 'Scotch Beach',
    shortDescription: 'Volleyball and bigger waves on north Crescent Beach',
    description:
        "Scotch Beach sits on the north side of Fred Benson Town Beach and is popular with the island's summer workers and young adults. Volleyball nets usually go up for pickup games and tournaments. The sand is fine and mostly free of rocks, and the surf can be good.\n\n"
        "Access is from a small parking area on Scotch Beach Road, which leads to a right-of-way to the sand.",
    category: PoiCategory.shore,
    lat: 41.190262,
    lng: -71.566224,
    imageAsset: 'assets/images/scotch-beach.jpg',
    visitorNote:
        'The parking lot is small. Posts along Corn Neck Road mark other access points. No lifeguard.',
    questIds: [],
    moduleIds: [],
  ),

  Poi(
    id: 'mansion-beach',
    name: 'Mansion Beach',
    shortDescription: 'North end of Crescent Beach with big surf, few people',
    description:
        "Mansion Beach is the north end of Crescent Beach, reached by a dirt road of the same name off Corn Neck Road. It has the biggest surf and the smallest crowds of the Crescent beaches. You park near the overgrown ruins of an old mansion, then walk down to the sand.\n\n"
        "The town bought the beach with help from the Block Island Conservancy, which covered a funding shortfall to keep it public.\n\n"
        "TODO(luke): source needed for the mansion's history. One source says the ruins belonged to the Searles Ball house; a lower-quality site gives a different name and a fire date.",
    category: PoiCategory.shore,
    lat: 41.201410,
    lng: -71.561139,
    imageAsset: 'assets/images/mansion-beach.jpg',
    visitorNote: 'Large surf. No lifeguard on duty.',
    questIds: [],
    moduleIds: [],
  ),

  Poi(
    id: 'clay-head-beach',
    name: 'Clay Head Beach',
    shortDescription: 'Beach at the foot of the Clay Head bluffs',
    description:
        "Clay Head Beach is reached on the Clay Head Trail. About a third of a mile in, at the first trail intersection, turning right takes you down to the beach. Turning left climbs onto the clay bluffs.\n\n"
        "TODO(luke): source needed for swimming conditions, parking, length of the beach and any seasonal restrictions.",
    category: PoiCategory.shore,
    lat: 41.206198,
    lng: -71.556929,
    imageAsset: 'assets/images/clay-head-beach.jpg',
    questIds: [],
    moduleIds: [],
  ),

  Poi(
    id: 'west-beach',
    name: 'West Beach',
    shortDescription: 'Quiet rocky beach for sea glass and sunsets',
    description:
        "West Beach is a secluded, rocky beach on the west side, reached by West Beach Road. It is not good for swimming or for lying out, but it is the island's best-known beach for sea glass and a peaceful place for a sunset walk.\n\n"
        "Parking is just past the town transfer station.",
    category: PoiCategory.shore,
    lat: 41.209780,
    lng: -71.577451,
    imageAsset: 'assets/images/west-beach.jpg',
    visitorNote: 'Rocky shoreline. Not suited to swimming.',
    questIds: [],
    moduleIds: [],
  ),

  Poi(
    id: 'coast-guard-beach',
    name: 'Coast Guard Beach',
    shortDescription: 'West-side beach by the old Coast Guard station',
    description:
        "Coast Guard Beach is on the Great Salt Pond side of the island, near the former Coast Guard station at the pond's entrance. That station was commissioned in January 1936. The Coast Guard ended year-round operations there in 1988, and the buildings went to the Town of New Shoreham in 1996 on the condition that quarters stay available for Coast Guard crews in summer.\n\n"
        "TODO(luke): source needed for the beach itself: exact location, access, parking and swimming conditions. The only sources found were a magazine mention of a small lot off Champlin Road near the old station and hotel-site distance listings.",
    category: PoiCategory.shore,
    lat: 41.195167,
    lng: -71.589103,
    imageAsset: 'assets/images/coast-guard-beach.jpg',
    questIds: [],
    moduleIds: [],
  ),

  Poi(
    id: 'charlestown-beach',
    name: 'Charlestown Beach',
    shortDescription: 'West-side jetty beach for fishing and sunsets',
    description:
        "Charlestown Beach runs south from the jetty that marks the entrance to New Harbor. The long jetty is a good fishing spot, and from the beach you can watch boats sail in and out of the harbor, especially around sunset. It is not a good beach for swimming.\n\n"
        "Access is from Coast Guard Road (also called Champlin Road) off West Side Road, just past the entrance to Champlin's Marina. Follow the dirt road and, where it turns sharply right near the end, the way to the beach is easy to spot.",
    category: PoiCategory.shore,
    lat: 41.195119,
    lng: -71.593107,
    imageAsset: 'assets/images/charlestown-beach.jpg',
    visitorNote: 'No parking, and the dirt access road is not for cars or mopeds.',
    questIds: [],
    moduleIds: [],
  ),

  Poi(
    id: 'graces-cove',
    name: "Grace's Cove",
    shortDescription: 'Pebbly west-side cove for sunset walks',
    description:
        "Grace's Cove is one of the pebbly, west-facing coves along the west side of the island, reached by a dirt road of the same name. Block Island Tourism groups it with Dorrie's and Cooneymus Coves as good for hiking and sunsets.\n\n"
        "TODO(luke): source needed for parking, swimming conditions and exact access point.",
    category: PoiCategory.shore,
    lat: 41.183231,
    lng: -71.601286,
    imageAsset: 'assets/images/graces-cove.jpg',
    visitorNote: 'Dirt access road lined with private homes.',
    questIds: [],
    moduleIds: [],
  ),

  Poi(
    id: 'dorries-cove',
    name: "Dorrie's Cove",
    shortDescription: 'Pebbly west-side cove for sunset walks',
    description:
        "Dorrie's Cove is one of the pebbly, west-facing coves along the west side of the island, reached by a dirt road. Block Island Tourism groups it with Grace's and Cooneymus Coves as good for hiking and sunsets.\n\n"
        "TODO(luke): source needed for parking, swimming conditions and exact access point. Spelling varies by source: 'Dorry's' (Block Island Tourism map) and 'Dories' (hotel sites).",
    category: PoiCategory.shore,
    lat: 41.173318,
    lng: -71.607963,
    imageAsset: 'assets/images/dorries-cove.jpg',
    visitorNote: 'Dirt access road lined with private homes.',
    questIds: [],
    moduleIds: [],
  ),

  Poi(
    id: 'black-rock-beach',
    name: 'Black Rock Beach',
    shortDescription: 'South shore surf spot with a long walk in',
    description:
        "Black Rock Beach is on the south shore, named for the large black rock offshore. It is the island's best-known surfing spot, with a series of small, secluded coves along the cliffs. You reach it from Snake Hole Road, and the walk in is part of the trip.\n\n"
        "Black Rock Road, a dirt road, also leads from Rodman's Hollow to Black Rock Point, and at low tide the beach is walkable for some distance in either direction.\n\n"
        "TODO(luke): source needed for the exact trail from the Hollow trailhead down to the sand.",
    category: PoiCategory.shore,
    lat: 41.147508,
    lng: -71.595246,
    imageAsset: 'assets/images/black-rock-beach.jpg',
    visitorNote:
        'Reach it on foot or by bike. Mopeds are not allowed on the access road, and parking is only a handful of spaces.',
    questIds: [],
    moduleIds: [],
  ),

  Poi(
    id: 'vaill-beach',
    name: 'Vaill Beach',
    shortDescription: 'Rocky, secluded south shore beach below the bluffs',
    description:
        "Vaill Beach is a rocky, private beach behind Mohegan Bluffs, under half a mile long. It is good for beachcombing, finding glass floats and surfing, and has some of the island's best sunsets with a view of the offshore wind farm.\n\n"
        "Find Painted Rock at the corner of Snake Hole Road. The trail starts across the road. The rock has been painted by islanders and visitors since 1961, and when it was damaged in 2006 workers found several inches of paint built up on it.",
    category: PoiCategory.shore,
    lat: 41.148263,
    lng: -71.576324,
    imageAsset: 'assets/images/vaill-beach.jpg',
    visitorNote:
        'Parking is very limited. Rough surf and rocks in the shallows make swimming risky.',
    questIds: [],
    moduleIds: [],
  ),

  Poi(
    id: 'ballards-beach',
    name: "Ballard's Beach",
    shortDescription: 'Lively beach beside the Old Harbor breakwater',
    description:
        "Ballard's Beach sits just south of Old Harbor's eastern breakwater, beside Ballard's Inn, with a tiki bar, food service and lifeguards in summer. It is the other lifeguarded beach on the island besides Fred Benson. Locals sometimes call this stretch Pebbly Beach.\n\n"
        "The inn has been rebuilt more than once. Ballard's Inn burned to the ground on June 19, 1986, and the owners rebuilt right away on a slightly smaller scale, reopening the following July.",
    category: PoiCategory.shore,
    lat: 41.173215,
    lng: -71.554318,
    imageAsset: 'assets/images/ballards-beach.jpg',
    questIds: [],
    moduleIds: [],
  ),

  // ─────────────────────── ORGANIZATIONS ───────────────────────

  // TODO(luke): source needed for current opening hours.
  Poi(
    id: 'block-island-historical-society',
    name: 'Block Island Historical Society',
    shortDescription: 'Island history museum in an 1871 house',
    description:
        "The Block Island Historical Society runs a museum at 18 Old Town Road, at the corner of Ocean Avenue (Bridgegate Square). It was founded in 1942 and works out of Woonsocket House, a three-story house built in 1871 that the society bought in 1945. The collection runs from Manissean stone tools to boat models, farm tools, fishing gear, quilts, historic maps and Victorian summer-resort photographs.\n\n"
        "The original Statue of Rebecca, which stood in the center of town for 105 years, is in the museum's West Gallery.",
    category: PoiCategory.historic,
    lat: 41.173633,
    lng: -71.562248,
    imageAsset: 'assets/images/block-island-historical-society.jpg',
    visitorNote: 'Open daily in summer. Off-season visits are by appointment.',
    questIds: [],
    moduleIds: [],
  ),

  // TODO(luke): source needed for when the Chamber was founded.
  Poi(
    id: 'block-island-chamber-of-commerce',
    name: 'Block Island Chamber of Commerce',
    shortDescription: 'Visitor Center across from the ferry landing',
    description:
        "The Block Island Chamber of Commerce is a nonprofit of nearly 300 members that promotes island businesses. It also runs the Visitor Center at 120 Water Street, directly across from the Old Harbor ferry landing, with support from the Block Island Tourism Council and the Town of New Shoreham. Staff can help plan your visit, and the center has island maps and nature trail maps.\n\n"
        "Single-use lockers are \$10 a day, and public bathrooms are two doors down in the same building. The center also rents wheelchairs, walkers and strollers for \$25 a day.",
    category: PoiCategory.organization,
    lat: 41.172776,
    lng: -71.557689,
    imageAsset: 'assets/images/block-island-chamber-of-commerce.jpg',
    visitorNote:
        'Hours change by season. The locker room closes after the last ferry leaves.',
    questIds: [],
    moduleIds: [],
  ),

  // TODO(luke): source needed for current opening hours. Two official
  // listings disagree on Sunday.
  Poi(
    id: 'island-free-library',
    name: 'Island Free Library',
    shortDescription: 'Town library on Dodge Street, founded in 1875',
    description:
        "The Island Free Library is at 9 Dodge Street. It began on March 6, 1875 as the Island Library Association, with annual dues of \$1 for men and 50 cents for women. The first collection was 250 volumes in one bookcase at the town hall. When the town hall burned on Halloween night in 1923, the library was destroyed.\n\n"
        "It moved into its current building in 1975, thanks to Lester Dodge. When he died in 1971 at 93, his will left nearly \$400,000 to the town to build and maintain a library on his family homestead on Dodge Street. The building has a children's room, a teen area and a section on island history.",
    category: PoiCategory.organization,
    lat: 41.173906,
    lng: -71.559718,
    imageAsset: 'assets/images/island-free-library.jpg',
    questIds: [],
    moduleIds: [],
  ),

  Poi(
    id: 'the-nature-conservancy',
    name: 'The Nature Conservancy',
    shortDescription: 'Conservation office and trail maps on High Street',
    description:
        "The Nature Conservancy's Block Island office is at 352 High Street. In 1991 the organization named Block Island one of 12 'Last Great Places' in the Western Hemisphere and set up a permanent field office soon after. Its Block Island Program manages more than 2,000 acres of habitat and, with the Block Island Conservancy, runs free guided nature programs through the year. Trail maps are available at the office.\n\n"
        "It also does long-term science on the Great Salt Pond, monitoring the pond to understand how it works.",
    category: PoiCategory.organization,
    lat: 41.169763,
    lng: -71.558223,
    imageAsset: 'assets/images/the-nature-conservancy.jpg',
    questIds: [],
    moduleIds: [],
  ),

  Poi(
    id: 'block-island-maritime-institute',
    name: 'Block Island Maritime Institute',
    shortDescription: 'Marine education and aquarium on the Great Salt Pond',
    description:
        "The Block Island Maritime Institute (BIMI) is at 216 Ocean Avenue, on the Great Salt Pond. It teaches marine science and maritime heritage to residents and visitors, with children's programs, an outdoor aquarium and guided harbor tours of the pond in a historic Oldport Launch.\n\n"
        "BIMI was founded in 1997 when a group of summer and year-round residents bought the historic Smuggler's Cove to keep it from being sold to a developer. The aquarium's five tanks hold species from the Great Salt Pond and the waters around the island.",
    category: PoiCategory.organization,
    lat: 41.180321,
    lng: -71.573475,
    imageAsset: 'assets/images/block-island-maritime-institute.jpg',
    visitorNote: 'Summer only. No daily programs from September to May.',
    questIds: [],
    moduleIds: [],
  ),

  // ───────────────────────── LANDMARKS ─────────────────────────

  Poi(
    id: 'settlers-rock',
    name: "Settlers' Rock",
    shortDescription: 'Memorial boulder listing the 1661 settler families',
    description:
        "Settlers' Rock is a boulder with a bronze plaque at the end of Corn Neck Road, at the edge of the parking lot at Cow Cove. It lists the names of the English families who settled Block Island, and marks the spot where they landed. Descendants put it up in 1911.\n\n"
        "The cove takes its name from the cattle. According to Livermore's 1877 history, the ship could not get close to shore, so the settlers pushed their cows overboard to swim in. North Light is about half a mile along the shoreline from here.",
    category: PoiCategory.landmark,
    lat: 41.225112,
    lng: -71.567332,
    imageAsset: 'assets/images/settlers-rock.jpg',
    visitorNote:
        'Strong riptides at Cow Cove, so no swimming. Rare birds nest on the beach.',
    questIds: [],
    moduleIds: [],
  ),

  Poi(
    id: 'statue-of-rebecca',
    name: 'Statue of Rebecca',
    shortDescription: 'Temperance fountain statue in the Old Harbor circle',
    description:
        "The Statue of Rebecca stands in the center of the traffic circle at Old Harbor, right where you walk off the ferry. The Women's Christian Temperance Union of Block Island dedicated it on July 22, 1896 as 'Rebecca at the Well,' part of a drinking fountain meant to give people something other than alcohol. It was meant to show Rebekah from the Book of Genesis.\n\n"
        "The statue you see now is a 2001 copy. The weathered original, a cast-iron figure, went to a conservation company in Newport, which made a mold for an aluminum replica that was put up that December. One account says the conservators found the figure looks more like Hebe, the cupbearer of the gods, than Rebekah. The original is now in the Historical Society's West Gallery, and the fountain no longer runs.",
    category: PoiCategory.landmark,
    lat: 41.172110,
    lng: -71.557405,
    imageAsset: 'assets/images/statue-of-rebecca.jpg',
    questIds: [],
    moduleIds: [],
  ),
];

// Full POI list consumed by the app; content_index.dart indexes this.
const List<Poi> kPois = [...poiBatch1, ...poiBatch2];
