import '../models/poi.dart';

// Batch 1: Mohegan Bluffs, Southeast Light, North Light
// Sourced from Wikipedia, blockislandinfo.com, newshorehamri.gov, blockislandferry.com
// See accompanying notes for unresolved source conflicts (heights, distances, battle dating).

const mohegheanBluffs = Poi(
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
  mapX: 0.0,
  mapY: 0.0,
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
  mapX: 0.0,
  mapY: 0.0,
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
  mapX: 0.0,
  mapY: 0.0,
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
  mohegheanBluffs,
  southeastLight,
  northLight,
];

const List<Poi> kPois = poiBatch1;
