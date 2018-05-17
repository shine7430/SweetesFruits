<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="CommunityOrderPage.aspx.cs" Inherits="AllTrustUs.SquirrelPocket.Order.CommunityOrderPage" %>

<%@ Register Src="~/UCOrder/CommunityOrder.ascx" TagPrefix="uc1" TagName="CommunityOrder" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentBody" runat="server">
    <uc1:CommunityOrder runat="server" id="CommunityOrder" />
</asp:Content>