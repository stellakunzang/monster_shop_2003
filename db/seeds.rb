# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Merchant.destroy_all
Item.destroy_all



#merchants
bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
mikes_shop = Merchant.create(name: "Mike's Amazon Regrets", address: '33 Prime Ave.', city: 'Denver', state: 'CO', zip: 80220)

#users with (role: set manually)
default_1 = User.create(name: "Hank Hill", address: "801 N Alamo St", city: "Arlen", state: "Texas", zip: "61109", email: "ProPAIN@aol.com", password: "W33dWacker", role: 0)
merchant_1 = User.create(name: "Maude Sloggett", address: "17 Sun Rise St", city: "El Paso", state: "Illinois", zip: "56726", email: "M.Slogget@yahoo.com", password: "Forever27", role: 1, merchant_id: dog_shop.id)
merchant_2 = User.create(name: "Paulie", address: "5 Sun Rise St", city: "Parker", state: "Illinois", zip: "56726", email: "Myneighborpaulie@hotmail.com", password: "Cigsrgood", role: 1, merchant_id: bike_shop.id)
admin_1 = User.create(name: "Kurt Cobain", address: "666 Lake Washington Bldv", city: "Seattle", state: "Washington", zip: "32786", email: "GrungeIsDead@gmail.com", password: "Forever27", role: 2)
#bike_shop items
tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
tassels = bike_shop.items.create(name: "Handle Bar Tassels", description: "WEEEEeee!!!", active?: true, price: 15, image: "https://images.freeimages.com/images/large-previews/0ba/i-love-pasta-1-1566263.jpg", inventory: 6)
seat = bike_shop.items.create(name: "Bike Seat", description: "Not for human consumption!", active?: true, price: 105, image: "https://media.istockphoto.com/photos/close-loose-toilet-seat-and-lid-isolated-on-white-picture-id598567074", inventory: 3)

#dog_shop items
pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

#mike_shop items
nikes = mikes_shop.items.create(name: "Nikes", description: "Forgot I already had two pairs of these", price: 90, image: "https://files.slack.com/files-pri/T029P2S9M-F014FP3SKB5/unadjustednonraw_thumb_12a9.jpg", inventory: 2)
dry_milk = mikes_shop.items.create(name: "Dry Milk", description: "Got thirsty but 220LBS was too much.", price: 26, image: "https://cdn.shopify.com/s/files/1/1115/1664/products/SKU_4703_ee701973-1ee8-477e-a1cb-ff972f6ff0e9.jpg?v=1571439436", inventory: 4)
statue = mikes_shop.items.create(name: "Statue", description: "Message me to talk about shipping", price: 1776, image: "https://ichef.bbci.co.uk/news/660/cpsprodpb/11E0D/production/_108292237_gettyimages-125966373.jpg", inventory: 1)
corn = mikes_shop.items.create(name: "Corn", description: "Might be haunted...", price: 1776, image: "https://media.giphy.com/media/LllA2dKt1qZuE/giphy.gif", inventory: 55)

# delete item
delete_item = bike_shop.items.create(name: "Mike Dao #1", description: "What an A plus project!", price: 10, image: "https://pbs.twimg.com/profile_images/1219492204193779712/-W-CA2jc_400x400.jpg", inventory: 2)

bone = dog_shop.items.create(name: "Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

toy = dog_shop.items.create(name: "Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

order = Order.create!(name: "name", address: "address", city: "city", state: "state", zip: 23455, user_id: default_1.id)
order2 = Order.create!(name: "name", address: "address", city: "city", state: "state", zip: 23455, user_id: default_1.id)

ItemOrder.create!(order_id: order.id, price: 1.0, item_id: dog_bone.id, quantity: 5)
ItemOrder.create!(order_id: order.id, price: 1.0, item_id: pull_toy.id, quantity: 1)
ItemOrder.create!(order_id: order.id, price: 1.0, item_id: tire.id, quantity: 4)
ItemOrder.create!(order_id: order.id, price: 1.0, item_id: toy.id, quantity: 3)
ItemOrder.create!(order_id: order.id, price: 1.0, item_id: bone.id, quantity: 2)
ItemOrder.create!(order_id: order2.id, price: 1.0, item_id: dog_bone.id, quantity: 3)
ItemOrder.create!(order_id: order2.id, price: 1.0, item_id: pull_toy.id, quantity: 4)
