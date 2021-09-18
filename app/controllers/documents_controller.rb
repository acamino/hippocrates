class DocumentsController < ApplicationController
  before_action :fetch_patient, :fetch_consultation
  before_action :fetch_document, only: [:edit, :update, :destroy]

  def index
    @documents = @consultation.documents.page(page)
  end

  def new
    @document = Document.new
  end

  def create
    @document = @consultation.documents.new(document_params)
    if @document.save
      redirect_to patient_consultation_documents_path(@patient, @consultation),
                  notice: 'Documento creado correctamente'
    else
      flash[:error] = 'Problema al crear el documento'
      render :new
    end
  end

  def edit; end

  def update
    if @document.update_attributes(document_params)
      redirect_to patient_consultation_documents_path(@patient, @consultation),
                  notice: 'Documento actualizado correctamente'
    else
      render :edit
    end
  end

  def destroy
    @document.destroy
    redirect_to patient_consultation_documents_path(@patient, @consultation),
                notice: 'Documento eliminado correctamente'
  end

  private

  def document_params
    attachments_attributes = raw_document_params[:attachments_attributes].to_h.merge(
      new_attachments_attributes
    )
    raw_document_params.merge(attachments_attributes: attachments_attributes)
  end

  def raw_document_params
    params.require(:document).permit(*Document::ATTRIBUTE_WHITELIST)
  end

  def new_attachments_attributes
    return {} unless params[:files].present?

    params[:files].inject({}) do |acc, file|
      acc.merge!(SecureRandom.hex => { content: file })
    end
  end

  def fetch_consultation
    @consultation = Consultation.find(params[:consultation_id])
  end

  def fetch_document
    @document = Document.find(params[:id])
  end
end
