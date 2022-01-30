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
### CRUD
Using ActiveRecord **Create**
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

Using ActiveRecord **Select**
```
Article.find(2)
Article.first
Article.last
articles = Article.all
```

Using ActiveRecord **Update**
```
article = Article.find(2)
article.title
article.description
article.description = "Edited - This is description"
article.save
```

Using ActiveRecord **Delete**
```
article = Article.find(2)
article.destroy
```

### Validations
Without validation the data with nil value can be inserted, to prevent that we need some validation before data included.
```ruby
class Article < ApplicationRecord
  validates :title, presence: true, length: {minimum:6, maximum:100}
  validates :description, presence: true, length: {minimum:10, maximum:100}
end
```
Using rails console
```
ror rails c
```
using below example irb console to tested out!
```irb
article = Article.new
article.save
article.errors.full_messages

article = Article.new(title: 'a', description: 'b')
article.errors.full_messages
```

## Frontend


### View **show**
Edit the `routes.rb`
```ruby
Rails.application.routes.draw do
  resources :articles, only: [:show]
end
```
Entering docker rails_web (**optional**)
```bash
docker exec -it rails_web /bin/bash
rails routes --expanded
```
Create Controller file `articles_controller.rb` in `/app/controllers`
```ruby
class ArticlesController < ApplicationController
  def show
    @article = Article.find(params[:id])
  end
end
```
Create folder `articles` in `/app/views` and create file `show.html.erb` in `/app/views/articles`
```erb
<h1> Showing articles details </h1>
<p><strong>Title: </strong><%=@article.title%></p>
<p><strong>Description: </strong><%=@article.description%></p>
```
and Access the url `http://localhost:3000/articles/1`

### View **index**
Edit `routes.rb`
```ruby
Rails.application.routes.draw do
  resources :articles, only: [:show, :index]
end
```

Add index in `articles_controller.rb`
```ruby
class ArticlesController < ApplicationController

  def show
    @article = Article.find(params[:id])
  end

  def index
    @articles = Article.all
  end

end
```

Create folder `articles` in `/app/views` and create file `index.html.erb` in `/app/views/articles`
```erb
<h1>Article list pages</h1>

<table>
  <thead>
    <tr>
      <th>Title</th>
      <th>Description</th>
      <th>Action</th>
    </tr>
  </thead>

  <tbody>
    <% @articles.each do |article| %>
      <tr>
        <td><%= article.title%></td>
        <td><%= article.description%></td>
        <td>Some action</td>
      </tr>
    <% end %>
  </tbody>
</table>
```
and Access the url `http://localhost:3000/articles`

### View **new**
Edit `routes.rb`
```ruby
Rails.application.routes.draw do
  root "articles#index"
  resources :articles, only: [:show, :index, :new, :create]
end
```

Add index in `articles_controller.rb`
```ruby
class ArticlesController < ApplicationController

  def show
    @article = Article.find(params[:id])
  end

  def index
    @articles = Article.all
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def article_params
      params.require(:article).permit(:title, :description)
    end
end
```

Create folder `articles` in `/app/views` and create file `new.html.erb` in `/app/views/articles`
```erb
<h1>Create a new Article</h1>

<%= form_with model: @article do |f|%>
  <p>
    <%= f.label :title%></br>
    <%= f.text_field :title%>
  </p>

  <p>
    <%= f.label :description%></br>
    <%= f.text_area :description%>
  </p>

  <p>
    <%= f.submit%>
  </p>
<%end%>
```
and Access the url `http://localhost:3000/articles/new`
## Debugging Rails using debugger
Add byebug in code, byebug will pause our rails app
```ruby
class ArticlesController < ApplicationController
  def show
    debugger
    @article = Article.find(params[:id])
  end
end
```
Interact with our rails application
```bash
docker attach rails_web
```
Check the `params`
```
params
params[:id]
continue
```