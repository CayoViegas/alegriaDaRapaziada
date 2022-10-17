import React from "react";
import './Card.css'

const PromotionCard = ({ promotion }) => (
    <div className="promotion-card">
        <img src={promotion.imageUrl} className="promotion-card__image" />
        <div className="promotion-card__info">
            <h1 className="promotion-card__title">{promotion.title} </h1>
            <span className="promotion-card__price"> R$ {promotion.price}</span>
            <footer className="promotion-card__footer">
                <div className="promotion-card__comments-count"> {promotion.comments.length} 
                {promotion.comments.length > 1 ? " Comentários":" Comentário"}
                </div>
                <a className="promotion-card__comments-link" href={promotion.url} target="_blanck" rel="noopener noreferrer"
                >Ir para o site</a>
            </footer>
        </div>
    </div>
)

export default PromotionCard;

