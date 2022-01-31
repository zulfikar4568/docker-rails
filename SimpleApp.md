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

Edit `articles_controller.rb`
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

### View **flash and validation**
Edit `articles_controller.rb`
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
      flash[:notice] = "Article was created successfully."
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

Edit file `new.html.erb` in `/app/views/articles`
```erb
<h1>Create a new Article</h1>

<% if @article.errors.any?%>
  <h2>The Following errors prevented the article being saved</h2>
  <ul>
    <% @article.errors.full_messages.each do |msg|%>
      <li><%= msg%></li>
    <%end%>
  </ul>
<%end%>

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

Add flash in `app/views/layouts/application.html.erb`
```erb
<!DOCTYPE html>
<html>
  <head>
    <title>App</title>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>

    <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
    <%= javascript_importmap_tags %>
  </head>

  <body>
    <% flash.each do |name, msg| %>
      <%= msg%>
    <% end %>
    <%= yield %>
  </body>
</html>

```
and Access the url `http://localhost:3000/articles/new`

### View **update**
Edit `routes.rb`
```ruby
Rails.application.routes.draw do
  root "articles#index"
  resources :articles, only: [:show, :index, :new, :create, :edit, :update]
end
```

Edit `articles_controller.rb`
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

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    @article.update(article_params)

    if @article.save
      flash[:notice] = "Article was updated successfully."
      redirect_to @article
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      flash[:notice] = "Article was created successfully."
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

Create file `edit.html.erb` in `/app/views/articles`
```erb
<h1>Edit Article</h1>

<% if @article.errors.any?%>
  <h2>The Following errors prevented the article being saved</h2>
  <ul>
    <% @article.errors.full_messages.each do |msg|%>
      <li><%= msg%></li>
    <%end%>
  </ul>
<%end%>

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
and Access the url `http://localhost:3000/articles/1/edit`

### View **delete**
Edit `routes.rb`
```ruby
Rails.application.routes.draw do
  root "articles#index"
  resources :articles
end
```

Edit `articles_controller.rb`
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

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    @article.update(article_params)

    if @article.save
      flash[:notice] = "Article was updated successfully."
      redirect_to @article
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    redirect_to root_path, status: :see_other
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      flash[:notice] = "Article was created successfully."
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

Edit `index.html.erb` in `/app/views/articles`
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
        <td><%= link_to 'Show', article_path(article)%></td>
        <td><%= link_to 'Delete', article_path(article), data: { "turbo-method": :delete, turbo_confirm: "Are you sure?" }%></td>
      </tr>
    <% end %>
  </tbody>
</table>
```
and Access the url `http://localhost:3000/articles/1/edit`
## Debugging Rails using debugger
Add debugger in code, debugger will pause our rails app
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

## DRY (Don't repear yourself) - Refactoring and Partials
Edit `articles_controller.rb`
```ruby
class ArticlesController < ApplicationController
  before_action :set_article, only: [:edit, :update, :show, :destory]

  def show
  end

  def index
    @articles = Article.all
  end

  def new
    @article = Article.new
  end

  def edit
  end

  def update
    @article.update(article_params)

    if @article.save
      flash[:notice] = "Article was updated successfully."
      redirect_to @article
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
    redirect_to root_path, status: :see_other
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      flash[:notice] = "Article was created successfully."
      redirect_to @article
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def article_params
      params.require(:article).permit(:title, :description)
    end

    def set_article
      @article = Article.find(params[:id])
    end
end
```

Add file `_messages.html.erb` in `app/views/layouts`
```erb
<% flash.each do |name, msg| %>
  <%= msg%>
<% end %>
```
Edit file `application.html.erb` in `app/views/layouts`
```erb
<!DOCTYPE html>
<html>
  <head>
    <title>App</title>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>

    <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
    <%= javascript_importmap_tags %>
  </head>

  <body>
    <%= render 'layouts/messages' %>
    <%= yield %>
  </body>
</html>

```
Add file `_form.html.erb` in `app/views/articles`
```erb
<% if @article.errors.any?%>
  <h2>The Following errors prevented the article being saved</h2>
  <ul>
    <% @article.errors.full_messages.each do |msg|%>
      <li><%= msg%></li>
    <%end%>
  </ul>
<%end%>

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
Edit file `edit.html.erb` in `app/views/articles`
```erb
<h1>Edit Article</h1>

<%= render 'form'%>

<%= link_to 'Cancel Return to a listing article', articles_path%>

```
Edit file `new.html.erb` in `app/views/articles`
```erb
<h1>Create a new Article</h1>

<%= render 'form'%>

<%= link_to 'Return to a listing article', articles_path%>
```
# One to Many Associations
## Create User Model
Generating Migration for user
```
rails generate migration create_users
```
`db/migrate/<migrate_file>.rb` add the username
```ruby
class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.timestamps
    end
  end
end
```
Migrate
```
ror rails db:migrate
```

Create file `user.rb` in `/app/model`
```ruby
class User < ApplicationRecord
  validates :username, presence: true, 
                        uniqueness: { case_sensitive: false }, 
                        length: {minimum: 3, maximum: 25}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
                    uniqueness: { case_sensitive: false }, 
                    length: {maximum: 105},
                    format: { with: VALID_EMAIL_REGEX }
end
```
You can test REGEX using web `rubular.com`

## Add user association with articles
Add migration file
```
ror rails generate migration add_user_id_to_articles
```

`db/migrate/<migrate_file>.rb` add the column user_id
```ruby
class AddUserIdToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :user_id, :int
  end
end
```
Migrate
```
ror rails db:migrate
```
Edit `user.rb` and `article.rb`
```ruby
class User < ApplicationRecord
  before_save { self.email = email.downcase }
  has_many :articles
  validates :username, presence: true, 
                        uniqueness: { case_sensitive: false }, 
                        length: { minimum: 3, maximum: 25}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
                    uniqueness: { case_sensitive: false }, 
                    length: { maximum: 105 },
                    format: { with: VALID_EMAIL_REGEX }
end

class Article < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, length: {minimum:6, maximum:100}
  validates :description, presence: true, length: {minimum:10, maximum:300}
end
```
Update all article with First user_id in rails console
```irb
Article.update_all(user_id: User.first.id)
Article.all
```
## 3 ways to insert data in one to many using rails console
Using Rails console
```bash
ror rails c
```
```irb
# First Method
user_1 = User.first
Article.create(title: "title article", desciption: "description", user_id: user_1.id)
#or
Article.create(title: "title article", desciption: "description", user: user_1)

# Second Method
user_1.articles.build(title: "title article", desciption: "description")
article = _
article.save
article.last


# Third Method
article = Article.new(title: "title article", desciption: "description")
user_2 = User.last
user_2.articles << article
```
## Add Password field and Securing the Password
Add bcrypt in Gemfile
```
gem "bcrypt", "~> 3.1.7"
```
and 
```
docker exec -it rails_web /bin/bash
bundle install
```
Add migration file
```bash
rails generate migration add_password_digest_to_users
```
And add the column inside file migration
```ruby
class AddPasswordDigestToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :password_digest, :string
  end
end
```
Migrating the database
```bash
rails db:migrate
rails c
```
Edit the `user.rb` and add `has_secure_password`
```ruby
class User < ApplicationRecord
  before_save { self.email = email.downcase }
  has_many :articles
  validates :username, presence: true, 
                        uniqueness: { case_sensitive: false }, 
                        length: { minimum: 3, maximum: 25}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
                    uniqueness: { case_sensitive: false }, 
                    length: { maximum: 105 },
                    format: { with: VALID_EMAIL_REGEX }
  has_secure_password
end
```
Test Bcrypt
```irb
password = BCrypt::Password.create("password")
password.salt

# add password into user
user = User.first
user.password = "Password123"
user.save
user
=begin
#<User:0x00007fb295058cd8                                       
 id: 1,                                                         
 username: "zulfikar",                                          
 email: "zulfikar@mail.com",                                  
 created_at: Mon, 31 Jan 2022 09:16:43.022658000 UTC +00:00,
 updated_at: Mon, 31 Jan 2022 11:36:46.206112000 UTC +00:00,
 password_digest: "[FILTERED]">
=end

user.authenticate("wrongpassword")
user.authenticate("Password123")
```
