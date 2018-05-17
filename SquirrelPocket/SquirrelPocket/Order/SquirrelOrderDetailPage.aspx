<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="SquirrelOrderDetailPage.aspx.cs" Inherits="AllTrustUs.SquirrelPocket.Order.SquirrelOrderDetailPage" %>

<%@ Register Src="~/UCOrder/SquirelOrderDetail.ascx" TagPrefix="uc1" TagName="SquirelOrderDetail" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentBody" runat="server">
    <uc1:SquirelOrderDetail runat="server" ID="SquirelOrderDetail" />
</asp:Content>
