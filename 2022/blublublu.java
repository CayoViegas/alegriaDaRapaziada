package br.com.gradeti.rfs.entity.core;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.PrePersist;
import javax.persistence.PreUpdate;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;
import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.Size;

import com.obadaro.jinah.common.util.Strings;
import com.obadaro.jinah.entity.annotation.BusinessKey;

import br.com.gradeti.fwk.model.annotations.CrudQueries;
import br.com.gradeti.fwk.model.annotations.RegStatus;
import br.com.gradeti.rfs.entity.armazem.layout.MapeamentoEnderecoAtivo;
import br.com.gradeti.rfs.entity.contrato.ContratoCliente;
import br.com.gradeti.rfs.entity.operacao.exp.ExpedicaoConferenciaDetalhe;
import br.com.gradeti.rfs.entity.pessoa.Pessoa;
import br.com.gradeti.rfs.entity.pessoa.Pessoa.TipoPessoa;
import br.com.gradeti.rfs.entity.produto.ClassificacaoProduto;
import br.com.gradeti.rfs.entity.produto.Fornecedor;
import br.com.gradeti.rfs.entity.produto.ImagemProduto;
import br.com.gradeti.rfs.entity.produto.ProdutoSimilar;
import br.com.gradeti.rfs.entity.produto.RestricaoProduto;
import br.com.gradeti.rfs.entity.produto.TipoProduto;
import br.com.gradeti.rfs.entity.spec.BusinessEntity;
import br.com.gradeti.rfs.entity.spec.Perecivel;
import br.com.gradeti.rfs.entity.spec.StatusCadastro;
import br.com.gradeti.rfs.entity.produto.ClassificacaoABC;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Ativo que será gerenciado.
 *
 *
 */
@Entity
@Table(name = "ativo")
@BusinessKey({ "mcid", "nome", "regStatus", "idContratoCliente" })
@NoArgsConstructor @Getter @Setter
@CrudQueries(edit = "Produto_edit")
public class Ativo extends BusinessEntity implements Perecivel {

    private static final long serialVersionUID = 3L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Long id;

    @NotEmpty 
    @Size(min = 3, max = 100)
    @Column(name = "nome", nullable = false, length = 100)
    private String nome;

    @Column(name = "IndicadorGrade", length = 1, nullable = false)
    private Boolean usaGrade;

    @Column(name = "IndicadorAssociacaoGrade", length = 1, nullable = false)
    private Boolean codificaGrade;

	@ManyToOne(fetch = FetchType.EAGER, optional=true, cascade= { CascadeType.DETACH })
    @JoinColumn(name = "idInformacaoAdicional", nullable=true)
	private InformacaoAdicional informacaoAdicional;

    @Column(name = "idContratoCliente", nullable = true)
    private Long idContratoCliente;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "idContratoCliente", nullable = true, insertable = false, updatable = false)
    private ContratoCliente contratoCliente;

    /** Flag para habilitar impressão em lote. */
    @Column(name = "indImprimivel", length = 1, nullable = true)
    private Boolean ativoImprimivel;

    @NotEmpty /*[] Adotar essa anotação ao invés de NotNull*/
    @Min(1)
    @Max(Integer.MAX_VALUE)
    @Column(name = "qtdeLimitePalletVirtual", nullable = false)
    private Integer limitePalletVirtual;
    
    @Max(Integer.MAX_VALUE)
    @Column(name = "qtdeLimiteBloco", nullable = true)
    private Integer limiteBloco;

    @OneToMany(mappedBy = "ativo", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private List<AtivoAtributo> atributosGrade;

    
    @OneToMany(mappedBy = "ativo", fetch = FetchType.LAZY, cascade = { CascadeType.DETACH, CascadeType.MERGE })
    private List<GradeItem> grade;

    @OneToMany(mappedBy = "ativo", fetch = FetchType.LAZY, cascade = { CascadeType.DETACH })
    private List<MapeamentoEnderecoAtivo> enderecosMapeados;
    
    @NotEmpty /*[] Adotar essa anotação ao invés de NotNull*/
	@Enumerated(EnumType.ORDINAL)
	@Column(name = "tipo", nullable = false)
    private TipoProduto tipo;
	
    @Enumerated(EnumType.ORDINAL)
	@Column(name = "IDENTIFICADOR_CURVA_ABC")
    private ClassificacaoABC classificacaoABC;
    
	@Size(min = 3)
	@Column(name = "descricao", nullable = true)
	private String descricao;

	@Size(max = 20)
	@Column(name = "idexterno", length = 20, nullable = true)
	private String idExterno;
		
	@Column(name = "codigoIntegracao", nullable = true)
	private String codigoIntegracao;
	
	@Column(name = "idEventoIntegracao", nullable = true)
	private String idEventoIntegracao;

	@Column(name = "tamanho", nullable = true)
	private Integer tamanho;

	@ManyToOne(fetch = FetchType.LAZY, cascade = { CascadeType.MERGE, CascadeType.DETACH })
	@JoinColumn(name = "idUnidadeTamanho", nullable = true)
	private UnidadeMedida unidadeTamanho;

	@ManyToOne(fetch = FetchType.LAZY, cascade = { CascadeType.MERGE, CascadeType.DETACH })
	@JoinColumn(name = "idUnidadeTamanhoSecundaria", nullable = true)
	private UnidadeMedida unidadeTamanhoSecundaria;

	/**
	 * Utilizado quando unidade de medida secundaria for informada.
	 */
	@Column(name = "fatorMultiplicacao", nullable = true)
	private Integer fatorMultiplicacao;

	@Column(name = "durabilidade", nullable = true)
	private Integer durabilidade;

	@ManyToOne(fetch = FetchType.LAZY, cascade = { CascadeType.MERGE, CascadeType.DETACH })
	@JoinColumn(name = "idTipoDurabilidade", nullable = true)
	private TipoDurabilidade tipoDurabilidade;

	@Column(name = "cubagem", precision = 10, scale = 6)
	private BigDecimal cubagem;

	@Column(name = "peso", precision = 10, scale = 3)
	private BigDecimal peso;

	@Size(min = 3, max = 100)
	@Column(name = "embalagem", length = 100, nullable = true)
	private String embalagem;

	@Size(min = 3, max = 100)
	@Column(name = "rotulagem", length = 100, nullable = true)
	private String rotulagem;

	@Size(min = 3, max = 100)
	@Column(name = "personalizacao", length = 100, nullable = true)
	private String personalizacao;

	@Size(min = 3)
	@Column(name = "observacao", nullable = true)
	private String observacao;

	@NotEmpty /*[] Adotar essa anotação ao invés de NotNull*/
	@Temporal(TemporalType.DATE)
	@Column(name = "dataInicioValidade", nullable = false)
	private Date dataInicioValidade;

	@Temporal(TemporalType.DATE)
	@Column(name = "dataFimValidade", nullable = true)
	private Date dataFimValidade;

	@Column(name = "indPermitirPlanejamentoExpedicaoSemEstoque", length = 1, nullable = false)
	private Boolean permitirPlanejamentoExpedicaoSemEstoque;	
	
	@ManyToOne(fetch = FetchType.LAZY, cascade = { CascadeType.MERGE, CascadeType.DETACH })
	@JoinColumn(name = "idClassificacao", nullable = true)
	private ClassificacaoProduto classificacao;

	@ManyToOne(fetch = FetchType.LAZY, cascade = { CascadeType.MERGE, CascadeType.DETACH })
	@JoinColumn(name = "idFabricante", nullable = true)
	private Fabricante fabricante;

	@ManyToOne(fetch = FetchType.LAZY, cascade = { CascadeType.MERGE, CascadeType.DETACH })
	@JoinColumn(name = "idResponsavel", nullable = true)
	private Responsavel responsavel;

	@ManyToOne(fetch = FetchType.LAZY, cascade = { CascadeType.MERGE, CascadeType.DETACH })
	@JoinColumn(name = "idModelo", nullable = true)
	private Modelo modelo;

	@OneToMany(mappedBy = "produto", fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
	private List<Fornecedor> fornecedores;

	@OneToMany(mappedBy = "produto", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
	private List<RestricaoProduto> restricoes;

	@OneToMany(mappedBy = "produto", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
	private List<ProdutoSimilar> similares;

	@OneToMany(mappedBy = "similar", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
	private List<ProdutoSimilar> similaresReverso;

	@ManyToOne(fetch = FetchType.LAZY, optional = true, cascade = CascadeType.ALL)
	@JoinColumn(name = "idImagem")
	private ImagemProduto imagem;
	
	@OneToMany(mappedBy = "ativo", fetch = FetchType.LAZY, orphanRemoval = true, cascade = CascadeType.ALL)
	private List<ExpedicaoConferenciaDetalhe> expedicaoConferenciaDetalhe;

	// Hoje só é possível associar 1 fornecedor.
	// No futuro deverá ser adaptado para trabalhar com N.
	@Transient
	private String prefixoFornecedor;

	@Transient
	private String nomeFornecedor;

	@Transient
	private String codBarras;
    
    
	@Transient
	private List<String> listaInformacaoAdicional;
    
    @Transient
    private String unidadePrimaria;

    @Transient
    private String unidadeSecundaria;
    
    @Transient
    private String nomeContratoCliente;

    /**
     * Atributo auxiliar para indicar se o ativo possui EPC associado.
     */
    @Transient
    private boolean possuiEpc;

    /**
     * Se listando itens da grade, esse é o id do GradeItem.
     */
    @Transient
    private Long idGradeItem;

    @Transient
    protected String nomeGradeItem;

    @Transient
    private Boolean imprimivel;

    /*[] Construtor 1*/
    /* Chama o super (padrão do sistema) */
    /* USADO */
    public Ativo(final String mcid) {
        super(mcid);
    }

    /*[] Construtor 4 (9 parâmetros)*/
    /* USADO. É o base da classe. Todos os chamam. */
    public Ativo(
            final String mcid, final Long id, final String nome,
            final Long idGradeItem, final String nomeGradeItem, final Boolean imprimivel,
            final Boolean gradeImprimivel, final Integer limitePalletVirtual, final RegStatus regStatus) {
        super(mcid);
        this.id = id;
        this.nome = nome;
        this.idGradeItem = idGradeItem;
        this.nomeGradeItem = nomeGradeItem;
        this.ativoImprimivel = imprimivel;
        this.limitePalletVirtual = limitePalletVirtual;

        this.imprimivel = Boolean.TRUE.equals(imprimivel) || Boolean.TRUE.equals(gradeImprimivel);
        this.regStatus = regStatus;
    }
    
    /*[] Construtor 1b (6 parâmetros)*/
    /* Chama o super (padrão do sistema) */
    /* USADO */
	public Ativo(final String mcid, final Long id, final String nome,
        		final Long idGradeItem, final String nomeGradeItem, final RegStatus regStatus) {
		this(mcid, id, nome, 
				idGradeItem, nomeGradeItem, null, null,
				null, null, null,
				null, null, null,
				null, null, null, 
				null, null, null, 
				null, null, null,
				null, null, regStatus,
				null, null, null, 
				null, null, null, 
				null, null, null,
				null,0);
	}

	/*[] Usado em Estoque*/
	/*[] Construtor 2 (13 parâmetros)*/
	/* Chama o 8 com pouca coisa */
	public Ativo(final String mcid, final Long id, final String nome, 
					final Long idGradeItem, final String nomeGradeItem, final String idExterno,
					final TipoProduto tipo, final Short idFabricante, final String nomeFabricante, 
					final Short idModelo, final String nomeModelo, final Long idContratoCliente, 
					final String nomeContratoCliente) {
		this(mcid, id, nome, 
				idGradeItem, nomeGradeItem, idExterno,
				tipo, null, null,
				null, null, null,
				idFabricante, nomeFabricante, idModelo, 
				nomeModelo, null, null, 
				null, null, null, null,
				null, null, null,
				null, null, null, 
				null, null, null, 
				null, idContratoCliente, null,
				nomeContratoCliente, 0);
	}
	
	/*[] Construtor 3 (15 parâmetros)*/
	/*Chama o 8 */
	public Ativo(final String mcid, final Long id, final String nome, 
					final String descricao, final Long idGradeItem, final String nomeGradeItem, 
					final String idExterno, final TipoProduto tipo, final Integer fatorMultiplicacao, 
					final BigDecimal cubagem, final InformacaoAdicional informacaoAdicional, final UnidadeMedida unidadeTamanho, 
					final UnidadeMedida unidadeTamanhoSecundaria, final Boolean permitirPlanejamentoExpedicaoSemEstoque, final RegStatus regStatus) {
		this(mcid, id, nome, 
				idGradeItem, nomeGradeItem, idExterno,
				tipo, null, null,
				null, null, null,
				null, null, null, 
				null, unidadeTamanho, null, 
				null,unidadeTamanhoSecundaria, null, 
				null, cubagem, fatorMultiplicacao, regStatus,
				informacaoAdicional, permitirPlanejamentoExpedicaoSemEstoque, null, 
				null, null, null, 
				null, null, descricao,
				null, 0);
	}	
	
	/*[] Construtor 4 (17 parâmetros)*/
	/* Chama o 8 com pouca coisa */
	public Ativo(final String mcid, final Long id, final String nome,
					final Long idGradeItem, final String nomeGradeItem, final String idExterno, 
					final TipoProduto tipo, final TipoPessoa tpForn, final String prefixoFornecedor,
					final String fornNomeCompleto, final String fornNomeReduzido, final StatusCadastro status,
					final Short idFabricante, final String nomeFabricante, final Short idModelo,
					final String nomeModelo, final RegStatus regStatus) {
		this(mcid, id, nome, 
				idGradeItem, nomeGradeItem, idExterno,
				tipo, tpForn, prefixoFornecedor,
				fornNomeCompleto, fornNomeReduzido, status,
				idFabricante, nomeFabricante, idModelo, 
				nomeModelo, null, null, 
				null, null, null, null,
				null, null, regStatus,
				null, null, null, 
				null, null, null, 
				null, null, null,
				null, 0);
	}
	
	/*[] Construtor 5 (21 parâmetros)*/
	/*Chama o 8 */
	public Ativo(final String mcid, final Long id, final String nome, 
					final Long idGradeItem, final String nomeGradeItem, final String idExterno, 
					final TipoProduto tipo, final TipoPessoa tpForn, final String prefixoFornecedor, 
					final String fornNomeCompleto, final String fornNomeReduzido, final StatusCadastro status, 
					final Short idFabricante, final String nomeFabricante,final Short idModelo, 
					final String nomeModelo, final BigDecimal cubagem, final Integer limitePalletVirtual, 
					final RegStatus regStatus, final Long idContratoCliente, final String nomeContratoCliente, 
					final int updateVersion) {
		this(mcid,id,nome,idGradeItem,
				nomeGradeItem,idExterno,tipo,
				tpForn,prefixoFornecedor,fornNomeCompleto,
				fornNomeReduzido,status,idFabricante,
				nomeFabricante,idModelo, nomeModelo, 
				null, null, null, 
				null, null, null, 
				cubagem, null, regStatus, 
				null, null, null, 
				null, limitePalletVirtual, null, 
				null, idContratoCliente, null, 
				nomeContratoCliente, updateVersion);
	}
	
	/* Chama o 8 */
	public Ativo(final String mcid, final Long id, final String nome,
					final Long idGradeItem, final String nomeGradeItem, final String idExterno, 
					final TipoProduto tipo, final TipoPessoa tpForn, final String prefixoFornecedor,
					final String fornNomeCompleto, final String fornNomeReduzido, final StatusCadastro status,
					final Short idFabricante, final String nomeFabricante, final Short idModelo,
					final String nomeModelo, final RegStatus regStatus, final Integer fatorMultiplicacao,
					final InformacaoAdicional informacaoAdicional, final Boolean ativoImprimivel, final Boolean gradeImprimivel) {
		this(mcid, id, nome, 
				idGradeItem, nomeGradeItem, idExterno,
				tipo, tpForn, prefixoFornecedor,
				fornNomeCompleto, fornNomeReduzido, status,
				idFabricante, nomeFabricante, idModelo, 
				nomeModelo, null, null, 
				null, null, null,
				null, null, fatorMultiplicacao, regStatus,
				informacaoAdicional, null, null, 
				null, null, ativoImprimivel, 
				gradeImprimivel, null, null, 
				null, 0);
	}
	
	/*Chama o 8 */
	public Ativo(final String mcid, final Long id, final String nome, 
					final Long idGradeItem, final String nomeGradeItem, final String idExterno, 
					final TipoProduto tipo, final TipoPessoa tpForn, final String prefixoFornecedor,
					final String fornNomeCompleto, final String fornNomeReduzido, final StatusCadastro status,
					final Short idFabricante, final String nomeFabricante, final Short idModelo, 
					final String nomeModelo, final Short idUnidadeTamanho, final String nomeUnidadeTamanho,
					final Short idUnidadeTamanhoSecundaria, final String nomeUnidadeTamanhoSecundaria, final BigDecimal cubagem, final Integer fatorMultiplicacao, 
					final RegStatus regStatus, final InformacaoAdicional informacaoAdicional, final Boolean permitirPlanejamentoExpedicaoSemEstoque,
					final Long idContratoCliente, final String nomeContratoCliente) {
		this(mcid, id, nome, 
				idGradeItem, nomeGradeItem, idExterno,
				tipo, tpForn, prefixoFornecedor, 
				fornNomeCompleto, fornNomeReduzido, status, 
				idFabricante, nomeFabricante, idModelo, 
				nomeModelo, null, idUnidadeTamanho, 
				nomeUnidadeTamanho, null, idUnidadeTamanhoSecundaria, 
				nomeUnidadeTamanhoSecundaria, cubagem, fatorMultiplicacao, regStatus, 
				informacaoAdicional, permitirPlanejamentoExpedicaoSemEstoque, null, 
				null, null, null, 
				null, idContratoCliente, null, 
				nomeContratoCliente, 0);	
	}
	
	
    /* USADO. É o base da classe. Todos os chamam. */
	/* É a versão mais completa */
	@Builder
	public Ativo(final String mcid, final Long id, final String nome, 
					final Long idGradeItem, final String nomeGradeItem, final String idExterno, 
					final TipoProduto tipo, final TipoPessoa tpForn, final String prefixoFornecedor,
					final String fornNomeCompleto, final String fornNomeReduzido, final StatusCadastro status,
					final Short idFabricante, final String nomeFabricante, final Short idModelo, 
					final String nomeModelo, final UnidadeMedida unidadeTamanho, final Short idUnidadeTamanho, 
					final String nomeUnidadeTamanho, final UnidadeMedida unidadeTamanhoSecundaria, final Short idUnidadeTamanhoSecundaria, 
					final String nomeUnidadeTamanhoSecundaria, final BigDecimal cubagem, final Integer fatorMultiplicacao, final RegStatus regStatus, 
					final InformacaoAdicional informacaoAdicional, final Boolean permitirPlanejamentoExpedicaoSemEstoque, final Short idResponsavel, 
					final String nomeResponsavel, final Integer limitePalletVirtual, final Boolean ativoImprimivel, 
					final Boolean gradeImprimivel, final Long idContratoCliente, final String descricao, 
					final String nomeContratoCliente, final int updateVersion) {
		super(mcid);
        this.id = id;
        this.nome = nome;
        this.idGradeItem = idGradeItem;
        this.nomeGradeItem = nomeGradeItem;
        this.ativoImprimivel = ativoImprimivel;
        this.limitePalletVirtual = limitePalletVirtual;

        this.imprimivel = Boolean.TRUE.equals(ativoImprimivel) || Boolean.TRUE.equals(gradeImprimivel);
        this.regStatus = regStatus;
		
		this.idExterno = idExterno;
		this.tipo = tipo;
		this.prefixoFornecedor = prefixoFornecedor;
		this.nomeFornecedor = (TipoPessoa.FISICA.equals(tpForn) ? fornNomeCompleto : Strings.ifBlank(fornNomeReduzido, fornNomeCompleto));
		this.status = status;
		if (idFabricante != null) {
			this.fabricante = new Fabricante(mcid);
			this.fabricante.setId(idFabricante);
			this.fabricante.setNome(nomeFabricante);
		}
		if (idModelo != null) {
			this.modelo = new Modelo(mcid);
			this.modelo.setId(idModelo);
			this.modelo.setNome(nomeModelo);
		}
		
		if (unidadeTamanho != null) {
			this.unidadeTamanho = unidadeTamanho; 
		} else {
			this.unidadeTamanho = UnidadeMedida.builder().mcid(mcid).id(idUnidadeTamanho).nome(nomeUnidadeTamanho).build();
			
		}
		this.unidadePrimaria = this.unidadeTamanho.getLabel(); 
		
		if (unidadeTamanhoSecundaria != null) {
			this.unidadeTamanhoSecundaria = unidadeTamanhoSecundaria;
		} else {
			this.unidadeTamanhoSecundaria = UnidadeMedida.builder().mcid(mcid).id(idUnidadeTamanhoSecundaria).nome(nomeUnidadeTamanhoSecundaria).build();
		}
		this.unidadeSecundaria = this.unidadeTamanhoSecundaria.getLabel();
		
		this.fatorMultiplicacao = fatorMultiplicacao;
		this.cubagem = cubagem;
		this.informacaoAdicional = informacaoAdicional;
		this.permitirPlanejamentoExpedicaoSemEstoque = permitirPlanejamentoExpedicaoSemEstoque;
		
		if (idResponsavel != null) {
			responsavel = new Responsavel(mcid);
			responsavel.setId(idResponsavel);
			responsavel.setNome(nomeResponsavel);
		}
		this.idContratoCliente = idContratoCliente;
		this.nomeContratoCliente = nomeContratoCliente;
		this.descricao = descricao;
		this.updateVersion = updateVersion;
	}
    
    
    @PrePersist
    @PreUpdate
    public void prePersist() {
        if (this.getAtivoImprimivel() == null) {
            this.setAtivoImprimivel(true);
        }
    }    
    
    /**
     * ====================================================
     *                MÉTODOS TRANSIENTES
     * ====================================================
     */
    
    /**
     */
    @Transient
    public void setFornecedorUnico(Pessoa p) {
        if (this.fornecedores == null) {
            this.fornecedores = new ArrayList<>();
        } else {
            this.fornecedores.clear();
        }
        /*[] não usei o construtor completo pois o mesmo inicia o atributo ID */
        Fornecedor f = new Fornecedor(this.getGtimeta().getMcid());
        f.setProduto(this);
        f.setPessoa(p);
        this.fornecedores.add(f);
    }
    
    /**
     * [] Getter necessário para funcionar a cópia de propriedades
     *  na importação de produto.
     */
    @Transient
    public Pessoa getFornecedorUnico() {
        if (this.fornecedores != null && !this.fornecedores.isEmpty()) {
            return this.fornecedores.get(0).getPessoa(); 
        }
        return null;
    }
    
    /**
	 * Retorna string com a quantidade por extenso, concatenando inteiro e
	 * fracionado e utilizando os nomes das unidades de mendida, se disponíveis.
	 * 
	 * @param ativo
	 * @param parteInteira
	 * @param fracao
	 * @return Quantidade por extenso utilizando nome da unidade de medida, se
	 *         disponível.
	 */
	@Transient
	public static String quantidadePorExtenso(final Ativo ativo, final Integer parteInteira, final Double pFracao,
			final Boolean isQtdReservada) {
        String fracao = null;
        
        if (ativo.getTipo().isParticionado()) {
            DecimalFormat df2 = new DecimalFormat("#0.000");
            fracao = df2.format(pFracao);
        } else {
            fracao = ((pFracao != null) ? pFracao.intValue() : 0) + ""; 
        }
        
        String medidaPrimaria = (ativo.getUnidadeTamanho() != null ? ativo.getUnidadeTamanho().getNome() : null);
        String medidaSecundaria =
            (ativo.getUnidadeTamanhoSecundaria() != null
                ? ativo.getUnidadeTamanhoSecundaria().getNome()
                : null);

        final StringBuilder sb = new StringBuilder();
        if (ativo.getTipo().equals(TipoProduto.INTEIRO)) {
            if (isQtdReservada) {
                if (parteInteira != null && parteInteira == 1 && fracao != null &&
                    pFracao.doubleValue() > 0) {
                    sb.append(fracao);
                    if (Strings.isNotBlank(medidaSecundaria)) {
                        sb.append(" ").append(medidaSecundaria);
                    }
                } else if (parteInteira != null && parteInteira > 1 && fracao != null &&
                    pFracao.doubleValue() > 0) {
                    final Integer parteInt = parteInteira - 1;
                    sb.append(parteInt);
                    sb.append(" ").append(medidaPrimaria);
                    sb.append(" e ");
                    sb.append(fracao);
                    sb.append(" ").append(medidaSecundaria);
                } else if (parteInteira != null && parteInteira > 0 &&
                    (fracao == null || pFracao.doubleValue() == 0)) {
                    sb.append(parteInteira);
                    if (Strings.isNotBlank(medidaPrimaria)) {
                        sb.append(" ").append(medidaPrimaria);
                    }
                }
            } else {
                if (parteInteira != null && (parteInteira > 0 || (parteInteira == 0 && (pFracao == null || pFracao.doubleValue() == 0)))) {
                    sb.append(parteInteira);
                    if (Strings.isNotBlank(medidaPrimaria)) {
                        sb.append(" ").append(medidaPrimaria);
                    }
                }
                if (fracao != null && pFracao != null && pFracao.doubleValue() > 0) {
                    if (sb.length() > 0) {
                        sb.append("; ");
                    }
                    sb.append(fracao);
                    if (Strings.isNotBlank(medidaSecundaria)) {
                        sb.append(" ").append(medidaSecundaria);
                    }
                }
            }
        } else {
            if (pFracao.doubleValue() != 0) {
                sb.append(fracao).append(" ").append(medidaSecundaria);
            }
            if (sb.length() > 0) {
                return sb.toString();
            }
        }
        if (sb.length() > 0) {
            return sb.toString();
        }
		return "0";
	}
    
    
    /**
     * Se listando itens da grade, esse é o nome do ativo concatenado com o nome do GradeItem.
     * Caso contrário, é o próprio nome do ativo.
     */
    @Transient
    public String getNomeComposto() {
        if (idGradeItem == null) {
            return nome;
        } else {
            return nome + " " + nomeGradeItem;
        }
    }
    

    /**
     * Retorna identificador que mescla o id do ativo + o idGradeItem, se esse último não for nulo.
     *
     * @param idAtivo
     * @param idGradeItem
     * @return
     */
    @Transient
    public static int getAtivoGradeKey(final Long idAtivo, final Long idGradeItem) {
        int hash = (idAtivo != null ? idAtivo.hashCode() : 0);
        if (idGradeItem != null) {
            hash = hash + (37 * idGradeItem.hashCode());
        }
        return hash;
    }

    /**
     * Retorna identificador que mescla o id do ativo + o idGradeItem, se esse último não for nulo.
     *
     * @return
     */
    @Transient
    public int getAtivoGradeKey() {
        return getAtivoGradeKey(getId(), getIdGradeItem());
    }
    
    @Transient
    public boolean hasInformacaoAdicional() {
    	return this.informacaoAdicional != null;
    }

}