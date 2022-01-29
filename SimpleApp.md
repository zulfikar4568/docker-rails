# Try create simple Blog App
## Create rails app
```
ror rails new .
ror rails generate migration create_articles
```
`db/migrate/<migrate_file>.rb` add the title and description
```ruby
class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
```
## Migrate database
```bash
ror rails db:migrate
ror rails db:rollback #For rollback a migration not recomended
```

Add some column
```bash
ror rails generate migration add_columns_to_articles
```
Add some column
```ruby
class AddColumnsToArticles < < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :column1, :datetime
    add_column :articles, :column2, :datetime 
  end
end
```

## Model
Create file `article.rb` in `/app/model`
```ruby
class Article < ApplicationRecord

end
```
Using Rails console
```bash
ror rails c
```

Using ActiveRecord
```irb
Article.all
Article.create(title: "First Article", description: "This is description")
# or
article = Article.new
article.title = "Second Article"
article.description = "This is description"
article
article.save
# or
article = Article.new(title: "Third Article", description: "This is description")
article.save

exit
```