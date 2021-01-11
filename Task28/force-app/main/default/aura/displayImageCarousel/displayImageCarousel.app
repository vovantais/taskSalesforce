<aura:component implements="flexipage:availableForAllPageTypes,force:hasRecordId" controller="displayImageController"
	access="global">

	<aura:handler name="init" action="{!c.doInit}" value="{!this}" />
	<aura:attribute name="files" type="List" />

	<div class="carousel-wrapp">
		<lightning:carousel disableAutoRefresh="false" disableAutoScroll="false" class="carousel">
			<aura:iteration items="{!v.files}" var="item">
				<lightning:carouselImage src="{!item}" alt="newYear" />
			</aura:iteration>
		</lightning:carousel>
	</div>
</aura:component>