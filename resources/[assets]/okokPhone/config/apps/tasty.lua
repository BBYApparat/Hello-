--[[ Tasty - Food delivery App ]]
--[[ Recommened to only use coordinates within the city ]]
return {
  orders_refresh_delay = 5 * 60 * 1000,               -- How often to generate new orders in milliseconds
  reward = { distance_rate = 0.1, account = 'bank' }, -- How much to pay per distance unit
  ped_models = {                                      -- Chosen randomly
    'a_f_m_eastsa_01', 'a_f_y_business_04', 'a_f_y_business_01', 'a_f_y_tourist_01', 'a_m_m_golfer_01',
    'a_m_m_salton_02', 'a_m_y_business_01', 'a_m_m_mlcrisis_01', 'a_m_y_gencaspat_01' },
  pickups = { {
    label = 'Jamaican Roast',
    coords = vector3(274.22, -834.63, 29.25),
  }, {
    label = 'Coffee Shop',
    coords = vector3(264.12, -981.41, 29.36),
  }, {
    label = 'Taco Bomb',
    coords = vector3(-656.34, -677.35, 31.52),
  }, {
    label = 'Liquor Hole',
    coords = vector3(-884.71057128906, -1158.6384277344, 5.0994310379028),
  } },
  droppoffs = { {
    label = 'Donald Trump',
    coords = vector3(-167.76, -661.74, 40.46),
  }, {
    label = 'Jerry Smith',
    coords = vector3(-213.91, -727.54, 33.55),
  } },
}
