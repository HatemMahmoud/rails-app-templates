## rails new <app-name> -J -T -m <path-to-template>

# Remove unnecessary files
remove_file 'public/index.html'
remove_file 'public/images/rails.png'

# Replace README
remove_file 'README'
create_file 'README.markdown'

# Download jQuery driver
run "curl -s -L https://github.com/rails/jquery-ujs/raw/master/src/rails.js > public/javascripts/rails.js"

# Set JavaScript :defaults
# application "  config.action_view.javascript_expansions[:defaults] = %w(https://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js rails)"
gsub_file 'config/application.rb', "config.action_view.javascript_expansions[:defaults] = %w()", "config.action_view.javascript_expansions[:defaults] = %w(https://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js rails)"

# Set gems
remove_file 'Gemfile'
create_file 'Gemfile', do <<-'GEMFILE'
gem 'rails', '3.0.5'
group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails', '~> 2.5'
end
GEMFILE
end

# Install gems
run 'bundle'

# Install RSpec
generate 'rspec:install'

# Create home page
generate 'controller pages'
inject_into_class 'app/controllers/pages_controller.rb', 'PagesController' do <<-'PAGES'
  def show
    render :template => "pages/#{params[:id].to_s.downcase}"
  end
PAGES
end
create_file 'app/views/pages/home.html.erb'
route "root :to => 'pages#show', :id => :home"
route "resources :pages, :only => :show"

# Initialize git repository
git :init