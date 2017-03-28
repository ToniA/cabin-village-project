-- Apartments configuration

apartment_configs = {
  {apartment = 'C', rooms = {{name = 'alakerta', delayed = 1}}},
--                             {name = 'yläkerta 1', delayed = 0}, 
--                             {name = 'yläkerta 2', delayed = 0}}},
  {apartment = 'D', rooms = {{name = 'alakerta', delayed = 1}}},
--                             {name = 'yläkerta 1', delayed = 0}, 
--                             {name = 'yläkerta 2', delayed = 0}}},
  {apartment = 'E', rooms = {{name = 'alakerta', delayed = 1}}}, 
--                             {name = 'yläkerta 1', delayed = 0}, 
--                             {name = 'yläkerta 2', delayed = 0}}}
}


apartments = {}
for i, apartment_config in pairs(apartment_configs) do
  table.insert(apartments, apartment_config["apartment"])
end