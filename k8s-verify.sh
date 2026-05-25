#!/bin/bash
# k8s-verify.sh — ShopEasy deployment verifier

NAMESPACE="shopeasy-dev"
echo "========================================="
echo "  ShopEasy Deployment Health Check"
echo "========================================="

echo ""
echo "1  PODS STATUS"
kubectl get pods -n $NAMESPACE
echo ""

echo "2  DEPLOYMENTS"
kubectl get deployments -n $NAMESPACE
echo ""

echo "3  SERVICES"
kubectl get services -n $NAMESPACE
echo ""

echo "4 ENDPOINTS (MOST IMPORTANT)"
kubectl get endpoints -n $NAMESPACE
echo ""

echo "5  LABEL VERIFICATION"
echo "--- Pod Labels ---"
kubectl get pods -n $NAMESPACE --show-labels
echo ""

echo "6  RECENT EVENTS (last 10)"
kubectl get events -n $NAMESPACE \
  --sort-by='.lastTimestamp' | tail -10
echo ""

echo "========================================="
echo "   If Endpoints show <none> → LABEL MISMATCH!"
echo "   If Pods not Running → kubectl describe pod <name>"
echo "========================================="
