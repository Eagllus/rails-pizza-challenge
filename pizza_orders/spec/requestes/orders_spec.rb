require 'rails_helper'

RSpec.describe "Orders", type: :request do
  describe "GET /orders" do
    it "renders the index page and displays pending orders" do
      pending_order = create(:order, state: "open")
      completed_order = create(:order, state: "completed")

      get orders_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("ID: #{pending_order.source_id}")
      expect(response.body).not_to include("ID: #{completed_order.source_id}")
    end
  end

  describe "PATCH /orders/:id" do
    let(:order) { create(:order, source_id: "order-101", state: :open) }

    it "updates the order state to completed" do
      patch order_path(order), params: { order: { state: "completed" } }
      expect(order.reload.state).to eq("completed")
    end

    it "redirects or returns success after update" do
      patch order_path(order), params: { order: { state: "completed" } }
      expect(response).to redirect_to(orders_path)
    end
  end
end