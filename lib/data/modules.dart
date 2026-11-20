import '../models/module.dart';

// Content budget: 10 modules (6 ecology, 4 history). Researched 2026-11-04;
// every claim traces to a URL in that module's `sources`. Where sources
// disagreed, the claim is left out and noted in a TODO above the module.
const List<Module> allModules = [..._ecology, ..._history];

// ─────────────────────────── ECOLOGY ───────────────────────────

const _ecology = <Module>[
  // TODO(luke): sources disagree on when clearing was complete. Block Island
  // Times (Hruska) says "completely deforested by 1714"; American Heritage
  // says it happened gradually "over the next two hundred years."
  Module(
    id: 'island-without-trees',
    category: ModuleCategory.ecology,
    title: 'How the island lost its trees',
    summary:
        'From forest to farmland to bayberry, and how nearly half the island came to be protected.',
    readMinutes: 3,
    relatedPoiIds: ['rodmans-hollow', 'the-nature-conservancy'],
    sections: [
      ModuleSection(
        heading: 'A forested island',
        body:
            "When Giovanni da Verrazzano sailed past in 1524, he described the island as \"full of hilles, covered with trees.\" The English settlers who arrived in 1661 still found it heavily forested.\n\n"
            "They cleared it for farmland and firewood. When the first excursionists came over in August 1830, they remarked on the absence of trees.",
      ),
      ModuleSection(
        heading: 'Peat, then coal',
        body:
            "With the forest gone, islanders heated their homes and cooked with peat. In 1846 a ship carrying hard coal went aground in Cow Cove, and coal eventually replaced peat as the island's main fuel.",
      ),
      ModuleSection(
        heading: 'Fields go back to shrub',
        body:
            "The 1938 hurricane wiped out the island's fishing fleet. Farms lost barns and livestock and gave what was left of the fields back to nature, and the hills grew over with bayberry.\n\n"
            "That shrubland is what you walk through today. On its upland refuge land, the U.S. Fish and Wildlife Service lists northern arrowwood, pokeweed, Virginia creeper, northern bayberry and pine.",
      ),
      ModuleSection(
        heading: 'Saving open space',
        body:
            "In 1972 a developer planned houses in and around Rodman's Hollow. Residents formed the Block Island Conservancy to stop it, and the first 37 acres took four years to buy. Working with The Nature Conservancy, the Block Island Land Trust, the Audubon Society of Rhode Island, RI DEM and the town, conservation groups have since protected almost half of the island's land.",
      ),
    ],
    sources: [
      'https://www.americanheritage.com/stumbling-block',
      'https://www.blockislandtimes.com/columnists/the-almost-harbor/article_57635ed4-bb72-4cfb-a241-ca96eb194ce7.html',
      'https://www.blockislandinfo.com/about-block-island/history/',
      'https://www.fws.gov/refuge/block-island',
      'https://biconservancy.org/about-bic/our-history/',
      'https://en.wikipedia.org/wiki/Block_Island',
    ],
  ),

  // TODO(luke): the Block Island meadow vole and TNC's grassland restoration
  // (said to date from 1995) appeared only in search snippets. Add them once
  // there is a page to cite.
  Module(
    id: 'wildlife-on-land',
    category: ModuleCategory.ecology,
    title: 'Rare wildlife on land',
    summary:
        'An endangered beetle, a threatened shorebird and the shrubland and beaches they depend on.',
    readMinutes: 2,
    relatedPoiIds: ['rodmans-hollow', 'north-light', 'the-nature-conservancy'],
    sections: [
      ModuleSection(
        heading: 'Two listed species',
        body:
            "Two federally listed species are known to breed on Block Island: the American burying beetle, which is endangered, and the piping plover, which is threatened. The Nature Conservancy says the island supports plants and animals that disappeared from the rest of southern New England decades ago.",
      ),
      ModuleSection(
        heading: 'The refuge at the north end',
        body:
            "Block Island National Wildlife Refuge was established in 1973 with 28 acres transferred from the U.S. Coast Guard, and has grown to 134 acres. It is mostly upland, with beach habitat at Cow Cove, Sandy Point, West Beach and Beane Point. Along the beach you will find beach grass, northern bayberry, wild rose and beach plum.\n\n"
            "The refuge also holds the largest gull colony in Rhode Island.",
      ),
      ModuleSection(
        heading: 'Before you walk',
        body:
            "Ticks are very common on Block Island. Check yourself after any walk through grass or shrubland.",
      ),
    ],
    sources: [
      'https://www.fws.gov/refuge/block-island',
      'https://www.fws.gov/refuge/block-island/about-us',
      'https://www.nature.org/en-us/get-involved/how-to-help/places-we-protect/block-island/',
    ],
  ),

  Module(
    id: 'atlantic-flyway',
    category: ModuleCategory.ecology,
    title: 'A stopover on the Atlantic Flyway',
    summary:
        'Why young songbirds and falcons land here each fall, and who has been counting them since 1967.',
    readMinutes: 3,
    relatedPoiIds: ['clay-head-trail', 'north-light', 'the-nature-conservancy'],
    sections: [
      ModuleSection(
        heading: 'Overshooting the mainland',
        body:
            "Block Island is internationally recognized as one of the most important migratory bird habitats on the East Coast. Each fall more than 70 species of migratory songbirds pass through. Many are young, inexperienced birds that overfly the mainland and get pushed out over the ocean. The island is where they land.",
      ),
      ModuleSection(
        heading: 'Banding at Clay Head',
        body:
            "The bird banding station at Clay Head has recorded migrating and resident songbirds every spring and fall since 1967. Elise Lapham started it, and it is one of the longest continuously running banding stations in the United States.",
      ),
      ModuleSection(
        heading: 'Berries before the crossing',
        body:
            "Research by Scott McWilliams's lab at the University of Rhode Island, supported by The Nature Conservancy for a quarter century, first documented birds switching from insects to berries before long-distance migration. The finding changed how the island's habitat is managed, in favor of berry-producing shrubs.",
      ),
      ModuleSection(
        heading: 'Falcons',
        body:
            "In 2012 the Biodiversity Research Institute found that the island hosts one of the largest concentrations of falcons on the Atlantic Flyway. It set up the Block Island Raptor Research Station, the first in southern New England, which has caught and released about 2,000 peregrine falcons, merlins, sharp-shinned hawks and northern harriers. Peregrines tracked from here winter in the Caribbean, Central America and South America.",
      ),
    ],
    sources: [
      'https://www.fws.gov/refuge/block-island/about-us',
      'https://www.nature.org/en-us/get-involved/how-to-help/places-we-protect/block-island/',
    ],
  ),

  // TODO(luke): one search result said gray seal numbers have risen every
  // year since monitoring began in 2019. Not on a fetched page, so left out.
  Module(
    id: 'seals-and-young-fish',
    category: ModuleCategory.ecology,
    title: 'Seals and young fish',
    summary:
        'Wintering seals on the rocks, and a summer nursery for nearly 100 kinds of fish.',
    readMinutes: 2,
    relatedPoiIds: [
      'north-light',
      'block-island-maritime-institute',
      'the-nature-conservancy',
    ],
    sections: [
      ModuleSection(
        heading: 'Winter seals',
        body:
            "Harbor seals come south from Canada and northern New England as the water cools, and spend the winter around the island. Late March is the peak. On March 27, 2025, 19 volunteers surveyed nearly the whole shoreline within an hour of low tide and counted 205 seals: 44 harbor seals and at least 161 gray seals. Most were at Sandy Point, with others at Old Harbor Point and Cormorant Cove.\n\n"
            "Seals haul out at low tide to rest. In rough surf and stiff wind they are less likely to come ashore.",
      ),
      ModuleSection(
        heading: 'A nursery in the pond',
        body:
            "From May to October, The Nature Conservancy and the RI Division of Marine Fisheries pull seine nets at sites around the Great Salt Pond. Since 2014 the survey has recorded nearly 100 finfish species. Most are baitfish such as silversides and mummichogs, along with young winter flounder, tautog, black sea bass, scup and squid.\n\n"
            "Warm-water strays turn up too, including butterflyfish and seahorses. In 2015 the survey caught juvenile bonefish, the farthest north they had ever been documented.",
      ),
    ],
    sources: [
      'https://savebay.org/2025-block-island-seal-count-44-harbor-seals-161-gray-seals/',
      'https://www.blockislandferry.com/block-island-animals/',
      'https://www.nature.org/en-us/get-involved/how-to-help/places-we-protect/block-island/',
      'https://ecori.org/2020-8-18-study-finds-block-island-salt-pond-an-oasis-for-fish/',
    ],
  ),

  // TODO(luke): sources disagree on the channel date (ecoRI: dug by hand in
  // the 1870s; Wikipedia: 1895) and the pond's size (673 vs 770 acres).
  // Both left out until one is confirmed.
  Module(
    id: 'great-salt-pond',
    category: ModuleCategory.ecology,
    title: 'The Great Salt Pond and its marshes',
    summary:
        "The island's only estuary, and how residents brought it back from raw sewage.",
    readMinutes: 4,
    relatedPoiIds: [
      'block-island-maritime-institute',
      'coast-guard-beach',
      'the-nature-conservancy',
    ],
    sections: [
      ModuleSection(
        heading: 'From fresh to salt',
        body:
            "The Great Salt Pond is Block Island's only estuary. As late as the mid-1800s it was a freshwater pond that occasionally broke through to the sea in storms, until a channel was dug to connect it to Block Island Sound. Today it is also called New Harbor.\n\n"
            "Half of the pond is more than 13 feet deep, and it reaches 55 feet at its deepest. Its 2,120-acre watershed covers about a third of the island.",
      ),
      ModuleSection(
        heading: 'Cleaning it up',
        body:
            "Until the late 1980s, boaters routinely pumped their wastewater straight into the pond, and shellfishing was banned because of the sewage. In 1987 residents formed the Committee for the Great Salt Pond. With the harbor master and RI DEM, the committee started a free pumpout service, and the town now runs five pumpout boats. Members also test the pond and the eight inflows that feed it.\n\n"
            "Shellfishing has come back, and the pond now has oyster farms and a kelp farm. The pressure has not gone away: about 1,000 visiting boats moor here on a typical summer weekend, and as many as 2,000 on holidays.",
      ),
      ModuleSection(
        heading: 'Eelgrass and marshes',
        body:
            "Eelgrass, once abundant in the pond, has all but disappeared. Along the Atlantic coast about half of all eelgrass has been lost, mostly to nutrient pollution from wastewater and fertilizer that clouds the water.\n\n"
            "At Beane Point, on the pond's north side, dunes, salt marshes and tidal flats are protected as a conservation area, part of it owned by the U.S. Fish and Wildlife Service. Andy's Way, a public beach, runs along its eastern shore.",
      ),
      ModuleSection(
        heading: 'What you can do',
        body:
            "If you arrive by boat, use the town's free pumpout boats. If you are staying in the watershed, skip lawn fertilizer.",
      ),
    ],
    sources: [
      'https://ecori.org/2021-4-7-great-salt-pond-from-cesspool-to-block-islands-signature-feature/',
      'https://www.cgspblockisland.org/about',
      'https://www.nature.org/en-us/about-us/where-we-work/united-states/rhode-island/stories-in-rhode-island/ocean-state-secrets-of-the-seagrass/',
    ],
  ),

  // TODO(luke): the green crab facts below come from Block Island Times
  // search excerpts; the full articles were rate-limited and not read.
  // Confirm each, and check soft-shell clams are still closed at launch.
  Module(
    id: 'pond-invaders',
    category: ModuleCategory.ecology,
    title: 'Invaders in the pond',
    summary:
        'European green crabs, the clams they eat, and the effort to bring the clams back.',
    readMinutes: 2,
    relatedPoiIds: ['block-island-maritime-institute'],
    sections: [
      ModuleSection(
        heading: 'Green crabs',
        body:
            "Invasive species have taken hold in and around the Great Salt Pond. The best known is the European green crab, the main predator of young soft-shell clams. Once a clam reaches about an inch and a half it can bury itself deep enough to be safe.",
      ),
      ModuleSection(
        heading: 'Trapping and replanting',
        body:
            "The town's Shellfish Commission and Harbors Department staff have trapped green crabs for several years, though scientists agree that eradicating them is not possible. There is now a market for live green crabs as bait.\n\n"
            "The commission has buried seed clams in plots near Andy's Way under fine mesh netting. Soft-shell clams are closed to harvest for now. The goal is to reopen them some day.",
      ),
    ],
    sources: [
      'https://ecori.org/2021-4-7-great-salt-pond-from-cesspool-to-block-islands-signature-feature/',
      'https://www.blockislandtimes.com/article/shellfish-commission-confronts-reality/60020',
      'https://www.blockislandtimes.com/news/if-you-can-t-beat-em-eat-em/article_e8b6eab1-68b0-4de5-94ee-d790511490b3.html',
      'https://wror.com/2026/08/24/block-island-shellfish-license-sales-reach-record-high-as-commission-pursues-sustainability/',
    ],
  ),
];

// ─────────────────────────── HISTORY ───────────────────────────

const _history = <Module>[
  // TODO(luke): sources disagree on what "Manisses" means ("Island of the
  // Little God" vs "Manitou's Little Island"), on which people named it
  // (Manissean vs Niantic), and on population (about 300 at settlement vs
  // 1,200-1,500 in 1664). All left out.
  Module(
    id: 'manisseans',
    category: ModuleCategory.history,
    title: 'The Manisseans',
    summary: "The island's first people, before and after English settlement.",
    readMinutes: 3,
    relatedPoiIds: ['block-island-historical-society'],
    sections: [
      ModuleSection(
        heading: 'Manisses',
        body:
            "The island's first people called it Manisses. Archaeological sites show they lived largely by hunting deer, catching fish and shellfish, and growing corn, beans and squash, moving between forest and shore with the seasons.\n\n"
            "The shores of the Great Salt Pond were one of their main places to live, with evidence going back to the Middle Woodland period. The area was listed on the National Register of Historic Places in 1990 as the Great Salt Pond Archeological District.",
      ),
      ModuleSection(
        heading: '1636',
        body:
            "In August 1636 Massachusetts Bay sent ninety men under John Endicott to the island. They burned sixty wigwams and all the cornfields and killed fourteen people. It was one of the events that led to the Pequot War.",
      ),
      ModuleSection(
        heading: 'After settlement',
        body:
            "In 1663 the settler Thomas Terry gave six acres at the island's largest fresh pond to four chief sachems, land that became known as the Indian Lands. Isaac Church, recorded as the island's last full-blooded Manissean, died in 1886 at age 100. Isaac's Corner, where Center Road meets Lakeside Drive and Cooneymus Road, is named for him.",
      ),
      ModuleSection(
        heading: 'Remembering',
        body:
            "In 2011 the Block Island Historical Society dedicated the Block Island Manissean Ancestral Stone. The society's museum displays Manissean stone tools and points.",
      ),
    ],
    sources: [
      'https://en.wikipedia.org/wiki/Block_Island',
      'https://en.wikipedia.org/wiki/Great_Salt_Pond_Archeological_District',
      'https://blockislandhistorical.org/our-building',
    ],
  ),

  // TODO(luke): sources disagree on the settler party (twelve growing to
  // sixteen vs sixteen buyers in 1660), so no count is given.
  Module(
    id: 'settlers-and-wars',
    category: ModuleCategory.history,
    title: 'Settlers, a pirate and two wars',
    summary:
        'How the island got its name, the 1661 landing at Cow Cove, and an island caught between navies.',
    readMinutes: 3,
    relatedPoiIds: ['settlers-rock', 'block-island-historical-society'],
    sections: [
      ModuleSection(
        heading: 'Named twice',
        body:
            "Giovanni da Verrazzano sighted the island in 1524 and named it Claudia, after Claude, Duchess of Brittany. The Dutch explorer Adriaen Block charted it in 1614 and named it after himself.",
      ),
      ModuleSection(
        heading: 'The 1661 landing',
        body:
            "After 1636 the Massachusetts Bay Colony claimed the island by conquest, and in 1658 sold it to a group headed by John Endicott. In 1661 English settlers led by John Alcock landed at Cow Cove, where Settlers' Rock now lists their names.\n\n"
            "In 1672 the Rhode Island General Assembly incorporated the island, and it took the name New Shoreham, after Shoreham in West Sussex, England.",
      ),
      ModuleSection(
        heading: 'Captain Kidd',
        body:
            "In 1699 the Scottish sailor William Kidd visited Block Island shortly before he was hanged for piracy.",
      ),
      ModuleSection(
        heading: 'Two wars',
        body:
            "During the Revolutionary War, islanders kept a lookout on Beacon Hill, 211 feet above sea level, and lit fires to warn when an enemy was in sight.\n\n"
            "In 1814, during the War of 1812, a Royal Navy squadron under Captain Sir Thomas Hardy briefly occupied the island. Islanders had already moved their livestock and food to Stonington. The squadron left for Stonington on August 9, 1814.",
      ),
    ],
    sources: [
      'https://en.wikipedia.org/wiki/Block_Island',
      'https://www.blockislandinfo.com/about-block-island/history/',
    ],
  ),

  // TODO(luke): Southeast Light move distance differs (200 vs about 300
  // feet; the POI uses 300), so it is left out here. "Palatine" is spelled
  // "Palantine" on blockislandinfo.com.
  Module(
    id: 'lights-and-wrecks',
    category: ModuleCategory.history,
    title: 'Boats, lighthouses and shipwrecks',
    summary:
        'An island with no natural harbor and dangerous water on every side.',
    readMinutes: 3,
    relatedPoiIds: [
      'north-light',
      'southeast-light',
      'mohegan-bluffs',
      'block-island-historical-society',
    ],
    sections: [
      ModuleSection(
        heading: 'The double-ender',
        body:
            "With no natural harbor, island fishermen launched from the beach. Between the late 1700s and the 1800s they developed the Block Island double-ender, an open sailboat with a pointed bow and stern that could face the surf in either direction without turning around. Its light, strong lapstrake hull could be hauled up and down the sand.\n\n"
            "From the 1840s into the early 20th century, about 50 double-enders fished from the island. The boat appears on the town's coat of arms and the Historical Society's logo.",
      ),
      ModuleSection(
        heading: 'North Light',
        body:
            "The island's first lighthouse went up at Sandy Point in 1829 and was washed out to sea. The granite tower standing there now, built in 1867, is the fourth on the site.",
      ),
      ModuleSection(
        heading: 'Southeast Light',
        body:
            "Southeast Light was first lit on February 1, 1875, on the edge of Mohegan Bluffs. As the bluffs eroded, the whole 2,000-ton building was moved back from the edge in 1993. It was named a National Historic Landmark in 1997.",
      ),
      ModuleSection(
        heading: 'Shipwrecks',
        body:
            "There have been at least five major shipwrecks in the waters off Block Island. In 1738 the Palatine caught fire and sank off Sandy Point. In 1907 the steamer Larchmont collided with the schooner Harry Knowlton, and island fishermen received Carnegie gold medals for saving survivors. In 1939 the 416-foot tanker Lightburne ran aground in front of Southeast Light. The crew was rescued, and the wreck is now a dive site.",
      ),
    ],
    sources: [
      'https://blockislandhistorical.org/double-ender-fund',
      'https://www.blockislandinfo.com/about-block-island/history/',
      'https://en.wikipedia.org/wiki/Block_Island_North_Light',
      'https://en.wikipedia.org/wiki/Block_Island_Southeast_Light',
    ],
  ),

  Module(
    id: 'resort-era',
    category: ModuleCategory.history,
    title: 'Harbors and the resort era',
    summary:
        'How a breakwater and a run of hotels turned a farming island into a summer town.',
    readMinutes: 3,
    relatedPoiIds: ['statue-of-rebecca', 'block-island-historical-society'],
    sections: [
      ModuleSection(
        heading: 'A harbor built by hand',
        body:
            "Block Island has no natural harbor. Limited to farming and fishing, its population could not grow past about 1,200. The federal government began a breakwater at Old Harbor in 1870, and it was finished in 1873, mostly by islanders.",
      ),
      ModuleSection(
        heading: 'Hotels',
        body:
            "The Spring House, built in 1854, is the oldest hotel on the island and is still open. In 1872 Nicholas Ball, who had made his fortune in the California Gold Rush, built the Ocean View, the island's largest hotel. President Ulysses S. Grant stayed there. It burned to the ground in 1966.\n\n"
            "The building that now houses the Historical Society was rebuilt in 1871 as a summer hotel, the Woonsocket House. The society bought it in 1945 and kept renting rooms to summer visitors until the 1970s.",
      ),
      ModuleSection(
        heading: 'The twentieth century',
        body:
            "In 1896 the Women's Christian Temperance Union put up the Statue of Rebecca in the center of town. The 1938 hurricane wiped out the fishing fleet. Block Island State Airport opened in 1950, and in 1974 Old Harbor became a historic district on the National Register.",
      ),
    ],
    sources: [
      'https://www.blockislandinfo.com/about-block-island/history/',
      'https://www.blockislandtimes.com/columnists/the-almost-harbor/article_57635ed4-bb72-4cfb-a241-ca96eb194ce7.html',
      'https://www.americanheritage.com/stumbling-block',
      'https://blockislandhistorical.org/our-building',
      'https://en.wikipedia.org/wiki/Block_Island',
    ],
  ),
];
