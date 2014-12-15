class RefreshAuditsController < ApplicationController
  before_action :set_refresh_audit, only: [:show, :edit, :update, :destroy]

  # GET /refresh_audits
  # GET /refresh_audits.json
  def index
    @refresh_audits = RefreshAudit.all
  end

  # GET /refresh_audits/1
  # GET /refresh_audits/1.json
  def show
  end

  # GET /refresh_audits/new
  def new
    @refresh_audit = RefreshAudit.new
  end

  # GET /refresh_audits/1/edit
  def edit
  end

  # POST /refresh_audits
  # POST /refresh_audits.json
  def create
    @refresh_audit = RefreshAudit.new(refresh_audit_params)

    respond_to do |format|
      if @refresh_audit.save
        format.html { redirect_to @refresh_audit, notice: 'Refresh audit was successfully created.' }
        format.json { render :show, status: :created, location: @refresh_audit }
      else
        format.html { render :new }
        format.json { render json: @refresh_audit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /refresh_audits/1
  # PATCH/PUT /refresh_audits/1.json
  def update
    respond_to do |format|
      if @refresh_audit.update(refresh_audit_params)
        format.html { redirect_to @refresh_audit, notice: 'Refresh audit was successfully updated.' }
        format.json { render :show, status: :ok, location: @refresh_audit }
      else
        format.html { render :edit }
        format.json { render json: @refresh_audit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /refresh_audits/1
  # DELETE /refresh_audits/1.json
  def destroy
    @refresh_audit.destroy
    respond_to do |format|
      format.html { redirect_to refresh_audits_url, notice: 'Refresh audit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_refresh_audit
      @refresh_audit = RefreshAudit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def refresh_audit_params
      params.require(:refresh_audit).permit(:period, :stamp)
    end
end
