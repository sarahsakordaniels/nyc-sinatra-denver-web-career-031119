class FiguresController < ApplicationController

get '/figures' do
  @figures = Figure.all
  erb :"figures/index"
  end

get '/figures/new' do
  @titles = Title.all
  @landmarks = Landmark.all
  erb :"figures/new"
end

post '/figures' do
  # binding.pry
  figure = Figure.create(params[:figure])
  title_ids = []
  landmark_ids = []

  params[:figure][:title_ids].each do |title_id|
    if title_id == String
      FigureTitle.create(
        :title_id => title_id.to_i,
        :figure_id =>figure.id
      )
    else
      title = Title.create(title_id)
      FigureTitle.create(
        :title_id => title.id,
        :figure_id => figure.id
      )
    end
  end

  params[:figure][:landmark_ids].each do |landmark_id|
    if landmark_id == String
      landmark = Landmark.find(landmark_id.to_i)
      landmark.update(figure_id: figure.id)
    else
      landmark = Landmark.create(
        name: landmark_id[:name],
        year_completed: landmark_id[:year_completed],
        figure_id: figure.id)
    end
  end

  redirect "/figures"
end

get '/figures/:id' do
  @figure = Figure.find(params[:id])
  erb :"figures/show"
end


end
