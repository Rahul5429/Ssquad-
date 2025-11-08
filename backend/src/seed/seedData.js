const Category = require('../models/Category');
const EventType = require('../models/EventType');
const Cuisine = require('../models/Cuisine');
const Country = require('../models/Country');
const ResponseOption = require('../models/ResponseOption');
const { TravelPurpose, AccommodationType, TravelAmenity } = require('../models/TravelMetadata');
const { RetailStoreType, RetailProductCategory } = require('../models/RetailMetadata');

const defaultCategories = [
  {
    title: 'Travel & Stay',
    slug: 'travel-stay',
    description: 'Book travel and accommodation options tailored to your events.',
    imageUrl:
      'https://static.toiimg.com/thumb/msid-92089121,width-748,height-499,resizemode=4,imgsize-139308/.jpg',
    order: 1,
  },
  {
    title: 'Banquets & Venues',
    slug: 'banquets-venues',
    description: 'Find the perfect venues for weddings, corporate events, and more.',
    imageUrl:
      'https://imgcdn.bookmywed.in/UploadImages/venue/5e589853-8ca0-4546-ab62-ac61c4a6364d-gallery.webp',
    order: 2,
  },
  {
    title: 'Retail Stores & Shops',
    slug: 'retail-stores',
    description: 'Discover curated retail partners for your event needs.',
    imageUrl:
      'https://imgcdn.bookmywed.in/UploadImages/venue/5e589853-8ca0-4546-ab62-ac61c4a6364d-gallery.webp',
    order: 3,
  },
];

const defaultEventTypes = [
  { name: 'Wedding' },
  { name: 'Anniversary' },
  { name: 'Corporate Event' },
  { name: 'Other Party' },
];

const defaultCuisines = [
  {
    name: 'Indian',
    imageUrl:
      'https://t4.ftcdn.net/jpg/02/84/46/89/360_F_284468940_1bg6BwgOfjCnE3W0wkMVMVqddJgtMynE.jpg',
  },
  {
    name: 'Italian',
    imageUrl:
      'https://img.freepik.com/free-photo/top-view-table-full-delicious-food-assortment_23-2149141339.jpg',
  },
  {
    name: 'Asian',
    imageUrl:
      'https://t3.ftcdn.net/jpg/02/60/12/88/360_F_260128861_Q2ttKHoVw2VrmvItxyCVBnEyM1852MoJ.jpg',
  },
  {
    name: 'Mexican',
    imageUrl:
      'https://thumbs.dreamstime.com/b/mexican-food-mix-colorful-background-mexico-66442136.jpg',
  },
];

const defaultCountries = [
  {
    name: 'India',
    code: 'IN',
    states: [
      {
        name: 'Maharashtra',
        cities: [
          { name: 'Mumbai' },
          { name: 'Pune' },
          { name: 'Nagpur' },
          { name: 'Nashik' },
          { name: 'Aurangabad' },
        ],
      },
      {
        name: 'Karnataka',
        cities: [
          { name: 'Bengaluru' },
          { name: 'Mysuru' },
          { name: 'Hubballi' },
          { name: 'Mangaluru' },
          { name: 'Belagavi' },
        ],
      },
      {
        name: 'Tamil Nadu',
        cities: [
          { name: 'Chennai' },
          { name: 'Coimbatore' },
          { name: 'Madurai' },
          { name: 'Tiruchirappalli' },
          { name: 'Salem' },
        ],
      },
      {
        name: 'Uttar Pradesh',
        cities: [
          { name: 'Lucknow' },
          { name: 'Kanpur' },
          { name: 'Agra' },
          { name: 'Varanasi' },
          { name: 'Noida' },
        ],
      },
      {
        name: 'Gujarat',
        cities: [
          { name: 'Ahmedabad' },
          { name: 'Surat' },
          { name: 'Vadodara' },
          { name: 'Rajkot' },
          { name: 'Gandhinagar' },
        ],
      },
    ],
  },
  {
    name: 'United States',
    code: 'US',
    states: [
      {
        name: 'California',
        cities: [
          { name: 'Los Angeles' },
          { name: 'San Francisco' },
          { name: 'San Diego' },
          { name: 'Sacramento' },
          { name: 'San Jose' },
        ],
      },
      {
        name: 'New York',
        cities: [
          { name: 'New York City' },
          { name: 'Buffalo' },
          { name: 'Rochester' },
          { name: 'Syracuse' },
          { name: 'Albany' },
        ],
      },
      {
        name: 'Texas',
        cities: [
          { name: 'Houston' },
          { name: 'Dallas' },
          { name: 'Austin' },
          { name: 'San Antonio' },
          { name: 'Fort Worth' },
        ],
      },
      {
        name: 'Florida',
        cities: [
          { name: 'Miami' },
          { name: 'Orlando' },
          { name: 'Tampa' },
          { name: 'Jacksonville' },
          { name: 'Tallahassee' },
        ],
      },
      {
        name: 'Illinois',
        cities: [
          { name: 'Chicago' },
          { name: 'Aurora' },
          { name: 'Naperville' },
          { name: 'Peoria' },
          { name: 'Springfield' },
        ],
      },
    ],
  },
  {
    name: 'United Arab Emirates',
    code: 'AE',
    states: [
      {
        name: 'Dubai',
        cities: [
          { name: 'Dubai' },
          { name: 'Jebel Ali' },
          { name: 'Hatta' },
          { name: 'Al Awir' },
          { name: 'Al Lisaili' },
        ],
      },
      {
        name: 'Abu Dhabi',
        cities: [
          { name: 'Abu Dhabi' },
          { name: 'Al Ain' },
          { name: 'Madinat Zayed' },
          { name: 'Ruwais' },
          { name: 'Liwa Oasis' },
        ],
      },
      {
        name: 'Sharjah',
        cities: [
          { name: 'Sharjah' },
          { name: 'Khor Fakkan' },
          { name: 'Al Dhaid' },
          { name: 'Kalba' },
          { name: 'Dibba Al-Hisn' },
        ],
      },
      {
        name: 'Ajman',
        cities: [
          { name: 'Ajman' },
          { name: 'Masfout' },
          { name: 'Manama' },
          { name: 'Al Jarf' },
          { name: 'Al Hamidiya' },
        ],
      },
      {
        name: 'Ras Al Khaimah',
        cities: [
          { name: 'Ras Al Khaimah' },
          { name: 'Al Jazirah Al Hamra' },
          { name: 'Digdaga' },
          { name: 'Ghalilah' },
          { name: 'Khatt' },
        ],
      },
    ],
  },
  {
    name: 'Australia',
    code: 'AU',
    states: [
      {
        name: 'New South Wales',
        cities: [
          { name: 'Sydney' },
          { name: 'Newcastle' },
          { name: 'Wollongong' },
          { name: 'Parramatta' },
          { name: 'Coffs Harbour' },
        ],
      },
      {
        name: 'Victoria',
        cities: [
          { name: 'Melbourne' },
          { name: 'Geelong' },
          { name: 'Ballarat' },
          { name: 'Bendigo' },
          { name: 'Shepparton' },
        ],
      },
      {
        name: 'Queensland',
        cities: [
          { name: 'Brisbane' },
          { name: 'Gold Coast' },
          { name: 'Cairns' },
          { name: 'Townsville' },
          { name: 'Sunshine Coast' },
        ],
      },
      {
        name: 'Western Australia',
        cities: [
          { name: 'Perth' },
          { name: 'Fremantle' },
          { name: 'Bunbury' },
          { name: 'Broome' },
          { name: 'Karratha' },
        ],
      },
      {
        name: 'South Australia',
        cities: [
          { name: 'Adelaide' },
          { name: 'Mount Gambier' },
          { name: 'Whyalla' },
          { name: 'Port Augusta' },
          { name: 'Port Lincoln' },
        ],
      },
    ],
  },
  {
    name: 'Canada',
    code: 'CA',
    states: [
      {
        name: 'Ontario',
        cities: [
          { name: 'Toronto' },
          { name: 'Ottawa' },
          { name: 'Mississauga' },
          { name: 'Hamilton' },
          { name: 'London' },
        ],
      },
      {
        name: 'British Columbia',
        cities: [
          { name: 'Vancouver' },
          { name: 'Victoria' },
          { name: 'Kelowna' },
          { name: 'Kamloops' },
          { name: 'Prince George' },
        ],
      },
      {
        name: 'Quebec',
        cities: [
          { name: 'Montreal' },
          { name: 'Quebec City' },
          { name: 'Laval' },
          { name: 'Gatineau' },
          { name: 'Sherbrooke' },
        ],
      },
      {
        name: 'Alberta',
        cities: [
          { name: 'Calgary' },
          { name: 'Edmonton' },
          { name: 'Red Deer' },
          { name: 'Lethbridge' },
          { name: 'Medicine Hat' },
        ],
      },
      {
        name: 'Manitoba',
        cities: [
          { name: 'Winnipeg' },
          { name: 'Brandon' },
          { name: 'Steinbach' },
          { name: 'Thompson' },
          { name: 'Selkirk' },
        ],
      },
    ],
  },
];

const defaultResponseOptions = [
  {
    label: '24 hours',
    description: 'Needs 1 extra point',
    hours: 24,
  },
  {
    label: '2 days',
    description: 'Standard response time',
    hours: 48,
  },
  {
    label: '1 week',
    description: 'Flexible response window',
    hours: 168,
  },
];

const defaultTravelPurposes = [
  { name: 'Business Travel', description: 'Corporate meetings, conferences, or events.' },
  { name: 'Leisure Trip', description: 'Vacation, leisure travel or staycation.' },
  { name: 'Wedding Group', description: 'Accommodation for wedding guests and family.' },
  { name: 'Team Retreat', description: 'Team outings, offsites, or retreats.' },
];

const defaultAccommodationTypes = [
  { name: 'Hotel', description: 'Full-service hotel stay.' },
  { name: 'Resort', description: 'Luxury resort experience.' },
  { name: 'Serviced Apartment', description: 'Apartment with hotel-like services.' },
  { name: 'Boutique Stay', description: 'Unique boutique property.' },
];

const defaultTravelAmenities = [
  { name: 'Airport Transfers' },
  { name: 'Breakfast Included' },
  { name: 'Conference Room' },
  { name: 'Pool Access' },
  { name: 'Spa Services' },
];

const defaultRetailStoreTypes = [
  { name: 'Fashion & Apparel', description: 'Clothing, footwear and accessories.' },
  { name: 'Electronics & Gadgets', description: 'Consumer electronics and devices.' },
  { name: 'Home & Lifestyle', description: 'Furniture, home decor, and lifestyle products.' },
  { name: 'Grocery & Gourmet', description: 'Food, grocery, and gourmet retail.' },
];

const defaultRetailProductCategories = [
  { name: 'Clothing' },
  { name: 'Footwear' },
  { name: 'Accessories' },
  { name: 'Consumer Electronics' },
  { name: 'Home Decor' },
  { name: 'Beauty & Wellness' },
  { name: 'Gourmet Food' },
];

const seedCollection = async (Model, data, identifier = 'name') => {
  const count = await Model.countDocuments();
  if (count === 0) {
    await Model.insertMany(data);
    console.log(`[seed] inserted ${data.length} ${Model.collection.collectionName}`);
  }
};

const runSeeders = async () => {
  await seedCollection(Category, defaultCategories, 'slug');
  await seedCollection(EventType, defaultEventTypes);
  await seedCollection(Cuisine, defaultCuisines);
  await seedCollection(Country, defaultCountries, 'code');
  await seedCollection(ResponseOption, defaultResponseOptions);
  await seedCollection(TravelPurpose, defaultTravelPurposes);
  await seedCollection(AccommodationType, defaultAccommodationTypes);
  await seedCollection(TravelAmenity, defaultTravelAmenities);
  await seedCollection(RetailStoreType, defaultRetailStoreTypes);
  await seedCollection(RetailProductCategory, defaultRetailProductCategories);
};

module.exports = runSeeders;

